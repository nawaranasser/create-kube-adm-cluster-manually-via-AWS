# nginx Test Deployment

After the Kubernetes cluster became Ready, nginx was deployed to verify that the cluster could run workloads.

## Create Deployment

```bash
kubectl create deployment nginx-demo --image=nginx
```

## Check Rollout

```bash
kubectl rollout status deployment/nginx-demo
```

## Scale Deployment

```bash
kubectl scale deployment nginx-demo --replicas=3
```

This asked Kubernetes to keep 3 nginx pods running.

## Check Pod Distribution

```bash
kubectl get pods -o wide
```

Result:

```text
POD                          STATUS    NODE           POD_IP
nginx-demo-98d9dcdf8-8lm7z   Running   k8s-worker-1   192.168.230.1
nginx-demo-98d9dcdf8-d8559   Running   k8s-worker-2   192.168.140.2
nginx-demo-98d9dcdf8-k2chm   Running   k8s-worker-2   192.168.140.1
```

This confirmed that the scheduler placed workloads on worker nodes.

## Expose nginx

```bash
kubectl expose deployment nginx-demo --type=NodePort --port=80
```

Service result:

```text
nginx-demo   NodePort   10.100.231.46   <none>   80:30147/TCP
```

## Test Access

```bash
curl -I http://100.26.248.186:30147
```

Result:

```text
HTTP/1.1 200 OK
Server: nginx/1.31.2
```

This confirmed that traffic reached the Kubernetes NodePort service successfully.
