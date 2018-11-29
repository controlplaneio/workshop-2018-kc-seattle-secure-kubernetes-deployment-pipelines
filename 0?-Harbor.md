# Harbor

Harbor is a CNCF project that combines the Docker Registry, Notary and Clair. This gives you image hosting, signing and scanning out of the box. We won't focus on Harbor too much as we have limited time but you can find out more [here](https://github.com/goharbor/harbor/blob/master/README.md). It's likely you may be using a hosted registry service that already supports vulnerability scanning and image signing that builds on top of the same open source software and therefore provides the same functionality. For example, IBM Container Registry and Azure Container Registry both provide Notary as a Service as part of their Container Registry as a Service offerings. To keep it local and consistent however, we will be using Harbor to provide this functionality.

## Setup

To install Harbor run:

```bash
kubectl apply -f setup/harbor.yaml
```

Head to  `https://192.168.99.100:30003/harbor/sign-in` to login to the Harbor UI. Username is `admin`, password is `kubecon1234`.

Configure content trust and image scanning for the default library project by selecting the library project, clicking the `Configuration` tab, unticking the first box and ticking all the others. This ensures that Harbor does the following:

- Auths users when pulling images from the registry.
- Only allows signed images to be pulled from the registry.
- Prevents any vulnerable images from being pulled from the registry.
- Automatically scans any images pushed to the registry for vulnerabilities.

Add your newly deployed registry located at `192.168.99.100:30003` to the list of insecure registries your Docker daemon is allowed to talk to. Do this by editing the daemon.json file, whose default location is `/etc/docker/daemon.json` on Linux. If you use Docker for Mac or Docker for Windows, click the Docker icon, choose Preferences, and choose Daemon.

If the daemon.json file does not exist, create it. Assuming there are no other settings in the file, it should have the following contents:
```json
{
  "insecure-registries" : ["192.168.99.100:30003"]
}
```

> Note because we can't get a certificate for our minikube IP address signed by a root CA we have to inform everything interacting with this registry to not verify certificates when communicating. Production systems/pipelines should verify certificates when interacting with a registry.

TODO:
* Add step to add insecure registry to minikube docker daemon
* Verify all these steps work by successfully deploying a new application to minikube via Harbor
