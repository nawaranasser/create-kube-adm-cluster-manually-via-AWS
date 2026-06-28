# Architecture

This lab uses a simple 3-node Kubernetes cluster on AWS EC2.

## Cluster Layout

```text
k8s-master     Control Plane
k8s-worker-1   Worker Node
k8s-worker-2   Worker Node
```

## High-Level Architecture

```text
Local Machine
    |
    | Terraform / SSH
    v
AWS Default VPC - us-east-1
    |
    +-- k8s-master
    |
    +-- k8s-worker-1
    |
    +-- k8s-worker-2
```

## Network Design

The lab uses the AWS Default VPC.

| Network | CIDR |
|---|---|
| AWS Default VPC | 172.31.0.0/16 |
| Kubernetes Pod Network | 192.168.0.0/16 |

The two CIDR ranges do not overlap.

## Why use the Default VPC?

The goal of this lab was to focus on Kubernetes and kubeadm, not advanced AWS networking.

Using the Default VPC reduced setup time and allowed the lab to focus on:

- EC2 instances
- SSH access
- Security Groups
- kubeadm cluster bootstrap
- Kubernetes networking
- Application deployment

## Node Roles

### k8s-master

Runs the Kubernetes control plane components:

- kube-apiserver
- kube-controller-manager
- kube-scheduler
- etcd

### k8s-worker-1 and k8s-worker-2

Run application workloads such as nginx pods.

## Important Note

This architecture is for learning only.

A production cluster would need more components, such as:

- Multiple control plane nodes
- Load balancer for the API server
- Highly available etcd
- Ingress controller
- Monitoring
- Logging
- Backup strategy
