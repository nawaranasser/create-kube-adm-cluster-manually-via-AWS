# Kubernetes Test Commands

## Create nginx Deployment

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

## Check Pods

```bash
kubectl get pods -o wide
```

## Expose Deployment

```bash
kubectl expose deployment nginx-demo --type=NodePort --port=80
```

## Check Service

```bash
kubectl get svc nginx-demo
```

## Test from Local Machine

```bash
curl -I http://<NODE_PUBLIC_IP>:<NODE_PORT>
```

Example from the lab:

```bash
curl -I http://100.26.248.186:30147
```

## Delete Test App

```bash
kubectl delete service nginx-demo
kubectl delete deployment nginx-demo
```
