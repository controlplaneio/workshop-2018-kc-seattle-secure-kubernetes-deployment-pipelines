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
