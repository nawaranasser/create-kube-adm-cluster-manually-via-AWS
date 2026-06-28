# Terraform Infrastructure

Terraform was used to provision the AWS infrastructure for this lab.

## Why Terraform?

Terraform allows infrastructure to be described as code.

Instead of manually creating EC2 instances from the AWS Console, the required infrastructure is written in `.tf` files and created with:

```bash
terraform apply
```

It can also be removed safely with:

```bash
terraform destroy
```

## Terraform Files

| File | Purpose |
|---|---|
| versions.tf | Defines Terraform and provider versions |
| provider.tf | Configures the AWS provider |
| variables.tf | Defines input variables |
| data.tf | Reads the AWS Default VPC and subnets |
| security.tf | Creates the Security Group and rules |
| compute.tf | Creates the EC2 instances and key pair |
| outputs.tf | Prints useful values such as IPs and SSH commands |

## Resources Created

Terraform created:

- AWS Key Pair
- Security Group
- EC2 instance for the control plane
- EC2 instance for worker 1
- EC2 instance for worker 2

## Security Group Rules

The Security Group allowed:

- SSH access from my public IP only
- NodePort range from my public IP only
- Internal traffic between Kubernetes nodes
- Outbound internet access

## Terraform Workflow

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

## Outputs

Useful Terraform outputs:

```bash
terraform output node_public_ips
terraform output node_private_ips
terraform output ssh_commands
```

## Cleanup

To delete the AWS resources created by Terraform:

```bash
terraform destroy
```

Terraform does not delete the AWS Default VPC because it was not created by this project.
