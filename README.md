# Kubernetes Cluster with kubeadm on AWS

A hands-on DevOps lab for building a Kubernetes cluster manually using `kubeadm` on AWS EC2 instances.

The AWS infrastructure was provisioned using Terraform, while Kubernetes was installed and configured manually to understand how a real Kubernetes cluster is bootstrapped step by step.

---

## Project Goal

The goal of this project is to build a simple Kubernetes cluster using `kubeadm`:

- 1 Control Plane node
- 2 Worker nodes
- `containerd` as the container runtime
- Calico as the CNI plugin
- nginx deployment for testing
- NodePort service to access nginx from outside the cluster

This is a learning lab, not a production-ready Kubernetes setup.

---

## Why This Project?

Before using managed Kubernetes services like Amazon EKS, it is important to understand how Kubernetes works internally.

This lab helped me practice:

- Creating cloud infrastructure with Terraform
- Connecting to EC2 instances using SSH
- Preparing Linux servers for Kubernetes
- Installing and configuring containerd
- Installing kubeadm, kubelet, and kubectl
- Initializing a Kubernetes control plane
- Joining worker nodes to the cluster
- Installing a CNI plugin
- Deploying and exposing a test application
- Cleaning up cloud resources safely

---

## Architecture

```text
Local Machine
    |
    | Terraform / SSH
    v
AWS Default VPC - us-east-1
    |
    +-- k8s-master     Control Plane
    |
    +-- k8s-worker-1   Worker Node
    |
    +-- k8s-worker-2   Worker Node
```

---

## Tools Used

- AWS EC2
- Terraform
- Ubuntu Server 22.04 LTS
- kubeadm
- kubelet
- kubectl
- containerd
- Calico CNI
- nginx

---

## Infrastructure Overview

Terraform was used to create the AWS infrastructure.

Resources created:

- AWS Key Pair
- Security Group
- 3 EC2 instances

The lab used the AWS Default VPC to reduce networking complexity and focus mainly on Kubernetes and kubeadm.

---

## Cluster Nodes

| Node | Role | Instance Type | Private IP | Kubernetes Version |
|---|---|---|---|---|
| k8s-master | Control Plane | t3.medium | 172.31.12.17 | v1.34.9 |
| k8s-worker-1 | Worker | t3.small | 172.31.11.203 | v1.34.9 |
| k8s-worker-2 | Worker | t3.small | 172.31.10.138 | v1.34.9 |

---

## Network Ranges

| Network | CIDR |
|---|---|
| AWS Default VPC | 172.31.0.0/16 |
| Kubernetes Pod Network | 192.168.0.0/16 |

The Pod CIDR does not overlap with the AWS VPC CIDR.

---

## Repository Structure

```text
.
├── README.md
├── SECURITY.md
├── progress.md
├── versions.tf
├── provider.tf
├── variables.tf
├── data.tf
├── security.tf
├── compute.tf
├── outputs.tf
├── docs/
│   ├── 01-architecture.md
│   ├── 02-terraform-infrastructure.md
│   ├── 03-node-preparation.md
│   ├── 04-kubeadm-cluster-setup.md
│   ├── 05-nginx-test.md
│   └── 06-cleanup.md
├── commands/
│   ├── 01-local-terraform-commands.md
│   ├── 02-linux-node-preparation-commands.md
│   ├── 03-kubeadm-commands.md
│   └── 04-kubernetes-test-commands.md
├── evidence/
│   ├── 01-terraform-public-ips.txt
│   ├── 02-terraform-private-ips.txt
│   ├── 03-kubectl-nodes.txt
│   ├── 04-system-pods.txt
│   ├── 05-nginx-deployment-service.txt
│   └── 06-nginx-curl-test.txt
└── screenshots/
```

---

## Phase 1: Provision AWS Infrastructure with Terraform

Terraform was used to create the EC2 instances and required networking access.

Basic Terraform workflow:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

After applying the Terraform configuration, the following nodes were created:

```text
k8s-master
k8s-worker-1
k8s-worker-2
```

Terraform outputs were used to get SSH commands and private IP addresses.

---

## Phase 2: Prepare Linux Nodes

The following preparation steps were applied to all nodes.

### Update packages

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
```

### Set hostnames

```bash
sudo hostnamectl set-hostname k8s-master
sudo hostnamectl set-hostname k8s-worker-1
sudo hostnamectl set-hostname k8s-worker-2
```

### Disable swap

```bash
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
```

Swap was disabled because Kubernetes needs predictable memory management.

---

## Kernel and Network Preparation

The following kernel modules were enabled:

```text
overlay
br_netfilter
```

### Why overlay?

`overlay` is used by the container runtime for layered container filesystems.

### Why br_netfilter?

`br_netfilter` allows Linux bridge traffic to be processed by networking rules, which is important for Kubernetes networking.

### sysctl settings

```bash
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
```

### Why IP forwarding?

Kubernetes nodes need to route traffic between pods, services, and nodes.  
`net.ipv4.ip_forward = 1` allows Linux to forward packets between interfaces.

---

## Phase 3: Install containerd

`containerd` was installed as the container runtime.

```bash
sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i "s/SystemdCgroup = false/SystemdCgroup = true/" /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd
```

The `SystemdCgroup = true` setting was enabled to match Kubernetes kubelet cgroup behavior.

---

## Phase 4: Install kubeadm, kubelet, and kubectl

The following tools were installed on all nodes:

| Tool | Purpose |
|---|---|
| kubeadm | Bootstrap the Kubernetes cluster |
| kubelet | Node agent that runs on every node |
| kubectl | CLI tool to interact with the cluster |

Installed Kubernetes version:

```text
v1.34.9
```

Verification:

```bash
kubeadm version -o short
kubelet --version
kubectl version --client
```

---

## Phase 5: Initialize the Control Plane

The Kubernetes control plane was initialized on the master node:

```bash
sudo kubeadm init \
  --apiserver-advertise-address=172.31.12.17 \
  --pod-network-cidr=192.168.0.0/16
```

After initialization, `kubectl` was configured for the `ubuntu` user:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

At this point, the master node appeared as `NotReady` because the CNI plugin had not been installed yet.

---

## Phase 6: Install Calico CNI

Calico was installed as the Kubernetes CNI plugin:

```bash
curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.32.0/manifests/calico.yaml
kubectl apply -f calico.yaml
```

After Calico was installed, the master node became `Ready`.

---

## Phase 7: Join Worker Nodes

The worker nodes were joined using the `kubeadm join` command generated by `kubeadm init`.

The actual join command is intentionally not included in this repository because it contains a temporary token.

General format:

```bash
sudo kubeadm join <MASTER_PRIVATE_IP>:6443 \
  --token <TOKEN> \
  --discovery-token-ca-cert-hash sha256:<HASH>
```

---

## Final Cluster Status

```text
NAME           STATUS   ROLES           AGE     VERSION
k8s-master     Ready    control-plane   22m     v1.34.9
k8s-worker-1   Ready    <none>          5m38s   v1.34.9
k8s-worker-2   Ready    <none>          2m42s   v1.34.9
```

The `<none>` role for worker nodes is normal. Kubernetes does not always assign a visible worker role label automatically.

---

## System Pods

After installing Calico and joining the workers, system pods were running successfully:

```text
calico-node
calico-kube-controllers
coredns
kube-proxy
kube-apiserver
kube-controller-manager
kube-scheduler
etcd
```

This confirmed that the control plane, CNI, DNS, and node networking were working.

---

## Phase 8: Deploy nginx Test Application

A test nginx deployment was created:

```bash
kubectl create deployment nginx-demo --image=nginx
```

The deployment was scaled to 3 replicas:

```bash
kubectl scale deployment nginx-demo --replicas=3
```

Pod distribution:

```text
POD                          STATUS    NODE           POD_IP
nginx-demo-98d9dcdf8-8lm7z   Running   k8s-worker-1   192.168.230.1
nginx-demo-98d9dcdf8-d8559   Running   k8s-worker-2   192.168.140.2
nginx-demo-98d9dcdf8-k2chm   Running   k8s-worker-2   192.168.140.1
```

This confirmed that Kubernetes could schedule workloads on the worker nodes.

---

## Phase 9: Expose nginx with NodePort

The nginx deployment was exposed using a NodePort service:

```bash
kubectl expose deployment nginx-demo --type=NodePort --port=80
```

Service result:

```text
NAME         TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nginx-demo   NodePort   10.100.231.46   <none>        80:30147/TCP   0s
```

NodePort used:

```text
30147
```

---

## External Access Test

nginx was tested from outside the cluster:

```bash
curl -I http://100.26.248.186:30147
```

Result:

```text
HTTP/1.1 200 OK
Server: nginx/1.31.2
```

This confirmed that external traffic reached the Kubernetes NodePort service and was routed successfully to the nginx pods.

---

## Evidence

Command outputs were saved in the `evidence/` directory:

```text
evidence/
├── 01-terraform-public-ips.txt
├── 02-terraform-private-ips.txt
├── 03-kubectl-nodes.txt
├── 04-system-pods.txt
├── 05-nginx-deployment-service.txt
└── 06-nginx-curl-test.txt
```

These files are useful for documentation and screenshots after the AWS resources are destroyed.

---

## Cleanup

First, delete the nginx test resources:

```bash
kubectl delete service nginx-demo
kubectl delete deployment nginx-demo
```

Then destroy the AWS infrastructure:

```bash
terraform destroy
```

After destroying the infrastructure, check the AWS Console for any remaining resources:

- Running EC2 instances
- EBS volumes
- Elastic IPs
- Load balancers
- NAT gateways
- Snapshots

This lab did not intentionally create Elastic IPs, Load Balancers, or NAT Gateways.

---

## Important Security Notes

Never commit the following files:

- SSH private keys
- AWS credentials
- Terraform state files
- `terraform.tfvars`
- kubeadm join tokens
- Any long-lived secrets

The `.gitignore` file is configured to exclude local sensitive files.

---

## What I Learned

Through this lab, I learned how to:

- Provision AWS infrastructure using Terraform
- Prepare Linux machines for Kubernetes
- Understand the role of containerd
- Bootstrap a Kubernetes control plane with kubeadm
- Join worker nodes to a cluster
- Install and verify a CNI plugin
- Deploy workloads using Kubernetes deployments
- Expose applications using NodePort
- Verify cluster health using kubectl
- Clean up cloud resources safely to avoid unnecessary cost

---

## Status

Lab completed successfully.

```text
Terraform: Infrastructure created successfully
Kubernetes: Cluster created successfully
Nodes: 3/3 Ready
CNI: Calico Running
Test App: nginx Running
External Access: HTTP 200 OK
```
