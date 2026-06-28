# Linux Node Preparation

Before creating the Kubernetes cluster, all nodes had to be prepared.

These steps were applied to:

- k8s-master
- k8s-worker-1
- k8s-worker-2

## 1. Update Packages

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
```

These packages are needed to install Kubernetes packages from the official repository.

## 2. Set Hostnames

Each node was given a clear hostname:

```bash
sudo hostnamectl set-hostname k8s-master
sudo hostnamectl set-hostname k8s-worker-1
sudo hostnamectl set-hostname k8s-worker-2
```

This makes the output of `kubectl get nodes` easier to understand.

## 3. Disable Swap

```bash
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
```

Kubernetes expects predictable memory behavior, so swap was disabled.

## 4. Enable Kernel Modules

```bash
cat <<EOC | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOC

sudo modprobe overlay
sudo modprobe br_netfilter
```

### overlay

Used by container runtimes for layered container filesystems.

### br_netfilter

Allows bridge network traffic to pass through Linux network filtering, which is required for Kubernetes networking.

## 5. Configure sysctl

```bash
cat <<EOC | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOC

sudo sysctl --system
```

### net.ipv4.ip_forward = 1

Allows the Linux node to forward network packets between interfaces.

This is important because pods and services need to communicate across nodes.

## 6. Install containerd

```bash
sudo apt-get install -y containerd

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null

sudo sed -i "s/SystemdCgroup = false/SystemdCgroup = true/" /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd
```

containerd is the container runtime used by Kubernetes to run containers.

## 7. Install Kubernetes Tools

The following tools were installed on all nodes:

- kubeadm
- kubelet
- kubectl

```bash
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

`apt-mark hold` prevents accidental upgrades that could cause version mismatch between nodes.

## Verification

```bash
kubeadm version -o short
kubelet --version
kubectl version --client
```

All nodes used:

```text
v1.34.9
```
