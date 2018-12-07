# Harbor

Harbor is a CNCF project that combines the Docker Registry, Notary and Clair. This gives you image hosting, signing and scanning out of the box. We won't focus on Harbor too much as we have limited time but you can find out more [here](https://github.com/goharbor/harbor/blob/master/README.md). It's likely you may be using a hosted registry service that already supports vulnerability scanning and image signing that builds on top of the same open source software and therefore provides the same functionality. For example, IBM Cloud Container Registry and Azure Container Registry both provide Notary as a Service as part of their Container Registry as a Service offerings. To keep it local and consistent however, we will be using Harbor to provide this functionality.

## Setup

To install Harbor run:

```bash
kubectl apply -f setup/harbor.yaml
```

### Add the Harbor CA to your machine's trusted CAs

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

### Verify

Verify that Harbor is now trusted by logging in to the registry.

```bash
docker login -u admin -p kubecon1234 192.168.99.100:30003
```

### Configure Harbor project to use Clair

Head to `https://192.168.99.100:30003/harbor/sign-in` to login to the Harbor UI. Username is `admin`, password is `kubecon1234`.

Turn on image scanning for the default library project by selecting the `library` project, clicking the `Configuration` tab, !!! TODO: @Andy/Pi decide how we want to use Clair, then fill this in !!!

!!! TODO: Verify all these steps work by successfully deploying a new application to minikube via Harbor !!!
