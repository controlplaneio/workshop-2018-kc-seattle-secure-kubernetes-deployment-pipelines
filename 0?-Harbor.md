# Harbor

Harbor is a CNCF project that combines the Docker Registry, Notary and Clair. This gives you image hosting, signing and scanning out of the box. We won't focus on Harbor too much as we have limited time but you can find out more [here](https://github.com/goharbor/harbor/blob/master/README.md). It's likely you may be using a hosted registry service that already supports vulnerability scanning and image signing that builds on top of the same open source software and therefore provides the same functionality. For example, IBM Container Registry and Azure Container Registry both provide Notary as a Service as part of their Container Registry as a Service offerings. To keep it local and consistent however, we will be using Harbor to provide this functionality.

## Setup

To install Harbor run:

```bash
kubectl apply -f setup/harbor.yaml
```

Head to `https://192.168.99.100:30003/harbor/sign-in` to login to the Harbor UI. Username is `admin`, password is `kubecon1234`. 

> Note: Your browser will probably complain that this connection is insecure. This is because to simplify this tutorial we told Harbor to use a self-signed certificate. Production systems/pipelines however, should use certificates signed by a trusted CA where possible.

Configure content trust and image scanning for the default library project by selecting the `library` project, clicking the `Configuration` tab, unticking the first box and ticking all the others. This ensures that Harbor does the following:

- Auths users when pushing/pulling images from the registry.
- Only allows signed images to be pulled from the registry.
- Prevents any vulnerable images from being pulled from the registry.
- Automatically scans any images pushed to the registry for vulnerabilities.

## Add Harbor to your list of insecure registries

Rather than mess around with your trusted CAs we will just whitelist the Harbor instance as an insecure registry. This will tell Docker that it doesn't need to verify that the certs it was presented with were signed by a trusted CA. Again, production systems/pipelines should use certificates signed by trusted CAs where possible.



TODO:
* Add screen grab of repo config to be more explicit
* Try to get self-signed ca working with Docker CLI
* Try to get self-signed ca working with Minikube Docker
* Verify all these steps work by successfully deploying a new application to minikube via Harbor
