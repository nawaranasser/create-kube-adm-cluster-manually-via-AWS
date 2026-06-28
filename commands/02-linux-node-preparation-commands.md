# Linux Node Preparation Commands

These commands were applied to all nodes: master and workers.

## Update Packages

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
```

## Set Hostname

```bash
sudo hostnamectl set-hostname k8s-master
sudo hostnamectl set-hostname k8s-worker-1
sudo hostnamectl set-hostname k8s-worker-2
```

## Disable Swap

```bash
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
```

## Kernel Modules

```bash
cat <<EOC | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOC

sudo modprobe overlay
sudo modprobe br_netfilter
```

## sysctl Network Settings

```bash
cat <<EOC | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOC

sudo sysctl --system
```

## Verify Kernel and Network Settings

```bash
lsmod | grep -E 'overlay|br_netfilter'
sysctl net.ipv4.ip_forward
```

## Install containerd

```bash
sudo apt-get update
sudo apt-get install -y containerd

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null

sudo sed -i "s/SystemdCgroup = false/SystemdCgroup = true/" /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd
systemctl is-active containerd
```

## Install Kubernetes Tools

```bash
sudo mkdir -p -m 755 /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /" \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

## Verify Versions

```bash
kubeadm version -o short
kubelet --version
kubectl version --client
```
