# Image Signing

## Notary

Notary is a CNCF project that implements The Update Framework (TUF) specification. It allows you to digitally sign and then verify the content of your container images at deploy time via their digest. Notary is typically integrated alongside a container registry to provide this functionality. In this tutorial Harbor is responsible for managing Notary.

TODO:
* Add steps to push a signed and unsigned image so we can use them later
* This will include creating the relevant signing keys, etc.

## Portieris

Portieris is a Kubernetes admission controller, open sourced by IBM. It integrates Notary image signing into your deployment pipelines by telling the Kubernetes API server to check with it whenever a resource that results in an image being run is created. It does this via a Mutating Admission Webhook.

TODO:
* Add Portieris deployment steps
* Investigate the default policies, explain why these aren't really secure.
* Remove the default cluster policy show that our unsigned image can be deployed
* Add a ban all images cluster wide, show a failed deploy.
* Whitelist the default namespace to enforce that all images from the library namespace images can be deployed if signed by a specific key.
