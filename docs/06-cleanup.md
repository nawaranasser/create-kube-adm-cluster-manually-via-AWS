# Cleanup

Cleanup is important because AWS resources continue to cost money while running.

## Delete Kubernetes Test Resources

```bash
kubectl delete service nginx-demo
kubectl delete deployment nginx-demo
```

## Destroy AWS Infrastructure

From the Terraform project directory:

```bash
terraform destroy
```

This removes the EC2 instances and other resources created by Terraform.

## Check AWS Console

After running `terraform destroy`, check the AWS Console for:

- Running EC2 instances
- EBS volumes
- Elastic IPs
- Load balancers
- NAT gateways
- Snapshots

This lab did not intentionally create Elastic IPs, Load Balancers, or NAT Gateways.

## Important

Do not forget this step.

Leaving EC2 instances running can create unnecessary AWS cost.
