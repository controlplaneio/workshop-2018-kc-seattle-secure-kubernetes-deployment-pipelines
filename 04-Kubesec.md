# kubesec plugin and admission controller

## Admission Control

1. Clone <https://github.com/stefanprodan/kubesec-webhook>

    ```bash
    git clone https://github.com/stefanprodan/kubesec-webhook
    cd kubesec-webhook
    ```

2. Generate the certificates for the webhook, deploy it, and label the `default` namespace so the admission controllers knows to validate its pods:

    ```bash
    make certs && make deploy
    kubectl label namespaces default kubesec-validation=enabled
    ```

    This deploys a `kubesec-webhook` pod in the `kubesec` namespace, a webhook admission controller configuration for the API server, and the secrets for secure communication.

3. Examine the webhook admission controller that's just been deployed:

    ```bash
    less deploy/webhook-registration.yaml
    ```

4. Find the `namespaceSelector` that corresponds to the label applied to the `default` namespace above. This is the only link between the admission controller and a namespace.

    Notice a CA bundle is required. This is because pod manifests may contain secrets in environment variables, or sensitive information about itself or other services. To ensure that the Kubernetes API trusts the admission controller, the CA bundle of the HTTPS endpoint that the API server POSTs to must be declared to establish a trust relationship between them.

    The secrets that are mounted into the admission controller are in `webhook-certs.yaml`, and the actual pod that's deployed is in `webhook.yaml`.

5. Try to deploy an insecure deployment:

    ```bash
    $ kubectl apply -f ./test/deployment.yaml
    Error from server (InternalError): error when creating "./test/deployment.yaml": Internal error occurred: admission webhook "deployment.admi
    ssion.kubesc.io" denied the request: deployment-test score is -30, deployment minimum accepted score is 0
    ```

6. The deployment is insecure. Let's check why. Create a Bash function to POST YAML to <https://kubesec.io.>

    > all sensitive configuration should live in `secrets` -  never leak configuration to a remote service.

    ```bash
    kubesec() {
        local FILE="${1:-}";
        [[ ! -f "${FILE}" ]] && {
            echo "kubesec: ${FILE}: No such file" >&2;
            return 1
        };
        curl --silent \
        --compressed \
        --connect-timeout 5 \
        -F file=@"${FILE}" \
        https://kubesec.io/
    }
    kubesec ./test/deployment.yaml
    ```

7. The problem is `containers[] .securityContext .privileged == true` - running a privileged pod.

    Although this is dangerous, perhaps we have an "urgent business requirement" (:facepalm:). Let's edit the admission controller to allow an insecure deployment:

    ```bash
    sed -i 's,-min-score=.*,-min-score=-100,' deploy/webhook.yaml
    kubectl delete -f deploy/webhook.yaml
    kubectl create -f deploy/webhook.yaml
    ```

8. Now anything with a score above `-100` will be allowed into the cluster! This is a bad thing. Let's test it:

    ```bash
    $ kubectl apply -f ./test/deployment.yaml
    deployment.apps "deployment-test" created
    ```

9. Now that we've deployed an insecure pod, let's change the admission controller risk threshold back to `0`.

    ```bash
    sed -i 's,-min-score=.*,-min-score=0,' deploy/webhook.yaml
    kubectl delete -f deploy/webhook.yaml
    kubectl create -f deploy/webhook.yaml
    kubectl get pods --selector=app=nginx
    ```

    Notice that the existing deployment is not affected - admission controllers are only called when an API call is "admitted" to the API server.
