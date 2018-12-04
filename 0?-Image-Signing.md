# Image Signing

## Creating signatures

Signing your images allows you to cryptographically verify the content of that image. You can use tools such as Portieris, which we'll cover later in this tutorial, to check image signatures at deploy time, to ensure that you trust the code that's running in your production environments. Some tools, including Harbor and Docker, refer to this feature as Content Trust.

Notary is a tool that manages signatures. It implements The Update Framework (TUF) (TODO add explanation of TUF). Both Notary and TUF are CNCF projects. Using Notary, you can digitally sign and then verify the content of your container images at deploy time via their digest. Notary is typically integrated alongside a container registry to provide this functionality. In this tutorial, we use Harbor as both the registry and the notary server.

1. Disable content trust (in case it was installed), then pull an image from the Docker registry to use in the tutorial:
    ```bash
    export DOCKER_CONTENT_TRUST=0
    docker pull hello-world
    ```
    > TODO: this could be the https://github.com/lukebond/demo-api as we want users to build and change it, but maybe not necessary until later?
1. Enable Docker Content Trust.
    ```bash
    export DOCKER_CONTENT_TRUST=1
    export DOCKER_CONTENT_TRUST_SERVER=https://192.168.99.100:30003
    ```
2. Push an image to Harbor. Your image will push as normal, but afterwards you'll be prompted to create passphrases for two signing keys:
    - Your root key, which is used to initialize repositories.
    - Your repository key, which is used to sign the image content.

    Make sure to set these passphrases to something that you remember, because you'll need to refer back to them. In this demo they can be the same thing, but in production it's safer to use different passphrases for each key.

    ```bash
    docker tag hello-world 192.168.99.100:30003/library/my-image:latest
    docker push 192.168.99.100:30003/library/my-image:latest
    ```
    
    > Here, `library` refers to the Project configured by default in Harbor
    
3. You can check your image signature by using `docker trust inspect 192.168.99.100:30003/library/my-image:latest`.

4. You've signed the image already using the repository key, but this key doesn't prove your identity. The repository key is also unique to that image repository, so you'll create different keys for each image repository that you sign. Notary lets the repository key holder add other people's key pairs so that they can sign the image.
    1. Create a signing key called `portierisdemo`.
        ```bash
        cd ~
        docker trust key generate portierisdemo
        ```
        The private key goes in to your Docker Content Trust directory. The public key is saved to `portierisdemo.pub` in your working directory.
        
    2. Add your key as a signer in Notary.
        ```bash
        docker trust signer add --key=portierisdemo.pub portierisdemo 192.168.99.100:30003/library/my-image
        ```

5. Let's push the same image, but unsigned, for comparison:
    ```bash
    unset DOCKER_CONTENT_TRUST
    docker tag hello-world 192.168.99.100:30003/my-unsigned-image:latest
    docker push 192.168.99.100:30003/my-unsigned-image:latest
    ```

1. To see the trust files stored on disk, examine the local `~/.docker` directory:
    ```bash
    tree ~/.docker
    ```
## Portieris

Portieris is a Kubernetes admission controller, open sourced by IBM. It integrates Notary image signing into your deployment pipelines by telling the Kubernetes API server to check with it whenever a resource that results in an image being run is created. It does this via a Mutating Admission Webhook.

1. Install Portieris.

    **TODO** add installation steps

    Portieris installs two custom Kubernetes resources for managing it: ImagePolicies and ClusterImagePolicies. If an ImagePolicy exists in the same Kubernetes namespace as your resources, Portieris uses that to decide what rules to enforce on your resources. Otherwise, Portieris uses the ClusterImagePolicy.

2. Out of the box, Portieris installs ImagePolicies into the `kube-system` and `ibm-system` namespaces, and a ClusterImagePolicy. Let's have a look at what's created.
    1. List your ClusterImagePolicies.
        ```bash
        kubectl get ClusterImagePolicies
        ```

        One ClusterImagePolicy is shown: `portieris-default-cluster-image-policy`.
    2. Edit the `portieris-default-cluster-image-policy` policy.
        ```bash
        kubectl edit ClusterImagePolicy portieris-default-cluster-image-policy
        ```

        Look at the `spec` section, and the `repositories` subsection inside it. One image is shown, with `name: "*"` and `policy: null`. `*` is a wildcard character, so this policy matches any image. When the policy is null, we don't apply any trust requirement. Essentially Portieris doesn't do anything at this point. Let's prove that quickly.

    3. Try to deploy an unsigned image to the cluster. We've created a deployment definition for you.

        ```bash
        kubectl apply -f myunsigneddeploy.yaml
        ```

        Portieris doesn't do anything with the deployment, so it's allowed to deploy.

    4. Let's enable trust enforcement for our image. Create a new element in the `repositories` list, after the `*`:
        ```yaml
        repositories:
            - name: "192.168.99.100:30003/library/my-image"
              policy:
                trust:
                  enabled: true
                  trustServer: "192.168.99.100:4443"
        ```

        Then save and close the file.

    5. Try to deploy your unsigned image again.

        **TODO** Create a deployment yaml that works from our image name. We can actually do this now we're using Harbor!

        ```bash
        kubectl apply -f myunsigneddeploy.yaml
        ```

        The deployment is rejected because it isn't signed.

        **TODO** add example message.

    6. Portieris doesn't prevent pods from restarting, even if the pod no longer satisfies your policy. This prevents you from getting an outage if your pods crash but they don't match your policy.

        Delete the pods in your deployment, and then watch as they are re-created.

        ```bash
        kubectl delete pods -l app=myunsigneddeploy
        kubectl get pods -l app=myunsigneddeploy --watch
        ```

    7. Try to deploy your signed image.

        ```bash
        kubectl apply -f mysigneddeploy.yaml
        ```

        This deployment is allowed.

    8. Edit the ClusterImagePolicy to enforce your particular signer.

        **TODO** Flesh this out

        1. Create a secret for the public key.
        2. Edit the ClusterImagePolicy to enforce it.

    9. Try to deploy your signed image again. This time, the deployment is rejected.

        **TODO** Add message

    10. Sign the image using your `portierisdemo` key. Images are automatically signed using all the keys that you have, so running the sign command adds a signature for your newly created key.
        ```bash
        docker trust sign 192.168.99.100:30003/library/my-image:latest
        ```

    11. Try to deploy your signed image once more. This time, the deployment is allowed.
