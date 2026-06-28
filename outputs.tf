output "ubuntu_ami_id" {
  description = "Ubuntu AMI ID used for instances"
  value       = data.aws_ami.ubuntu.id
}

output "default_vpc_id" {
  description = "Default VPC ID used by the lab"
  value       = data.aws_vpc.default.id
}

output "selected_subnet_id" {
  description = "Default subnet selected for the EC2 instances"
  value       = data.aws_subnets.default.ids[0]
}

output "node_public_ips" {
  description = "Public IP addresses of Kubernetes nodes"
  value = {
    for name, instance in aws_instance.nodes :
    name => instance.public_ip
  }
}

output "node_private_ips" {
  description = "Private IP addresses of Kubernetes nodes"
  value = {
    for name, instance in aws_instance.nodes :
    name => instance.private_ip
  }
}

output "ssh_commands" {
  description = "SSH commands for all nodes"
  value = {
    for name, instance in aws_instance.nodes :
    name => "ssh -i ./kubeadm-lab-key ubuntu@${instance.public_ip}"
  }
}
