# Harbor

Harbor is a CNCF project that combines the Docker Registry, Notary and Clair. This gives you image hosting, signing and scanning out of the box. We won't focus on Harbor too much as we have limited time but you can find out more [here](https://github.com/goharbor/harbor/blob/master/README.md). It's likely you may be using a hosted registry service that already supports vulnerability scanning and image signing that builds on top of the same open source software and therefore provides the same functionality. For example, IBM Cloud Container Registry and Azure Container Registry both provide Notary as a Service as part of their Container Registry as a Service offerings. To keep it local and consistent however, we will be using Harbor to provide this functionality.

## Setup
When running a cluster, you would normally add the Harbor CA to your cluster's trusted CAs. Since we are using a local minikube for our cluster, we will just start minikube with making an exception for harbor as an insecure registry. First get your Minikube IP. Minikube may take a minute to start.

```bash
minikube start
minikube ip
minikube stop
```

Then start the cluster with the insecure registry flag.

```bash
minikube start --insecure-registry=<Minikube_IP>:30003
```

We will deploy our registry as an application in minikube, using the harbor setup. To install Harbor run:

```bash
kubectl apply -f setup/harbor.yaml
```
This step can take a few minutes. You can check the progress by accessing the application at <Minikube_IP>:30003 in your browser or taking a look at the cluster state.

```bash
kubectl get all
```

This step can take a few minutes. In the meantime, add the certificate to your local machine.

### Add the Harbor CA to your machine's trusted CAs
Adding the certificates to your machine's trusted CAs is not necessary to deploy into the cluster, but we will need it for later steps using Notary.

Retrieve the CA cert from Kubernetes

```bash
kubectl get secrets -o json harbor-harbor-nginx | jq -r '.data["ca.crt"]' | base64 -d > harbor-ca.crt
```

Add trusted root certificate

#### OSX

```bash
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain harbor-ca.crt
# Then restart your Docker Daemon for it to take effect.
```

#### Ubuntu/Debian

```bash
sudo cp harbor-ca.crt /usr/local/share/ca-certificates/harbor-ca.crt
sudo update-ca-certificates
```

#### Windows

```bash
certutil -addstore -f "ROOT" harbor-ca.crt
# Then restart your Docker Daemon for it to take effect.
```

Verify that Harbor is now trusted by logging in to the registry.

```bash
docker login -u admin -p kubecon1234 <Minikube_IP>:30003
```

If you get a 400 Bad Requets error, wait a minute and try again.
Head to `<Minikube_IP>:30003/harbor/sign-in` to login to the Harbor UI. Username is `admin`, password is `kubecon1234`. You may need to add a security exception in the browser as the certificate issuer is untrusted.

### Configure Harbor project to use Clair
Turn on image scanning for the default library project by selecting the `library` project, clicking the `Configuration` tab. Select `Prevent vulnerable images from running` and set the threshold to high. This will prevent vulnerable images with one or more `high` vulnerability CVEs from getting pulled from this registry. Set the option to scan on push.

Now build the image to be scanned. Clone the demo-API https://github.com/lukebond/demo-api onto your local machine and check out the `kubecon` branch.

```bash
git clone https://github.com/lukebond/demo-api.git
cd demo-api
git checkout kubecon
```

Build and push into Harbor with

```bash
docker build . -t <Minikube_IP>:30003/library/demo-api:vulnerable
docker push <Minikube_IP>:30003/library/demo-api:vulnerable
```

In the Harbor UI, enter the library project and view the demo-api image. If the `vulnerability` column shows as `not scanned`, head to the `Configuration tab` in the left hand side menu, click `vulnerability` and check if there is a date stamp for `Database updated on`. If you see a notification icon, Harbor is still downloading its CVE database, which can take some time depending on bandwidth. Wait until you see the time stamp, kick off a scan and return to the pushed image. The vulnerability rating should be showing as `HIGH`, indicating that there is one or more strong vulnerabilities in the image.

### Deploy vulnerable image

Edit the setup/demo-api.yaml file in this repo by replacing `<Minikube_IP>` with the minikube IP you found in a previous step. Enter the workshop repo and attempt to deploy the image from the registry into your minikube cluster.

```bash
kubectl apply -f setup/demo-api.yaml
```

Check if it has deployed with

```bash
kubectl get po
```

If you have configured harbor correctly, you will notice that the pod has an `ErrImagePull` error. Investigate why with

```bash
kubectl describe po <pod name>
```

As expected, the event log shows that the image was denied based on its high vulnerability.

### Fix and deploy secure images

To fix this, we need to update the dockerfile with a secure base image.

In the Dockerfile, change the base image to `alpine:3.4`, rebuild and push

```bash
docker build . -t <Minikube_IP>:30003/library/demo-api:secure
docker push <Minikube_IP>:30003/library/demo-api:secure
```

Then change the deployment yaml `demo-api.yaml` to reference your new secure image, with the secure tag and redeploy.

```bash
kubectl apply -f setup/demo-api.yaml
```

Check if the pod has come up. Due to port limitations in Minikube, if your pod throws a `CrashLoopBackOff` error, you can delete the service with `kubectl delete service/demo-api`, wait for the pod to come up and then reapply the yaml above.
If you go to your browser and enter your cluster IP with the port defined in the yaml, `http://<Minikube_IP>:30009/` you will see the demo api has been deployed successfully.
