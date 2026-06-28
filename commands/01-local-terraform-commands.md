# Local Terraform Commands

These commands were executed from the local machine.

## Verify Tools

```bash
terraform version
aws --version
```

## Verify AWS Profile

```bash
aws sts get-caller-identity --profile kubeadm-lab
```

## Generate SSH Key

```bash
ssh-keygen -t ed25519 -f ./kubeadm-lab-key -C "kubeadm-lab"
chmod 400 ./kubeadm-lab-key
```

## Terraform Workflow

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

## Terraform Outputs

```bash
terraform output node_public_ips
terraform output node_private_ips
terraform output ssh_commands
```

## Get Default VPC CIDR

```bash
aws ec2 describe-vpcs \
  --profile kubeadm-lab \
  --region us-east-1 \
  --vpc-ids <DEFAULT_VPC_ID> \
  --query "Vpcs[0].CidrBlock" \
  --output text
```

## Destroy

```bash
terraform destroy
```
