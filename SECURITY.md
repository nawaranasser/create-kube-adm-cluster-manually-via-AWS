# Security Notes

This repository is for a learning Kubernetes lab.

The project uses Terraform to create AWS EC2 instances, then kubeadm to manually build a Kubernetes cluster.

## Do Not Commit Secrets

Never commit the following files or values:

- SSH private keys
- AWS credentials
- Terraform state files
- terraform.tfvars
- kubeadm join tokens
- Any long-lived secrets

## Files That Must Stay Local

The following files should stay only on the local machine:

```text
kubeadm-lab-key
terraform.tfvars
terraform.tfstate
terraform.tfstate.backup
.terraform/
```

## SSH Keys
The private key must never be committed:


## kubeadm-lab-key
The public key is not private, but it is not required in this repository because anyone using the project should generate their own key.

## Terraform State
Terraform state files may contain sensitive infrastructure information.

## Do not commit:


*.tfstate
*.tfstate.*
kubeadm Join Token
The kubeadm join command contains a temporary token.

Do not publish the real join command.

Use this safe format in documentation:

## Bash
```
sudo kubeadm join <MASTER_PRIVATE_IP>:6443 \
  --token <TOKEN> \
  --discovery-token-ca-cert-hash sha256:<HASH>
```  
Before Pushing to GitHub
Always run:

Bash```
git status --short
Make sure none of these files appear:
```

## kubeadm-lab-key
terraform.tfvars
terraform.tfstate
terraform.tfstate.backup
.terraform/