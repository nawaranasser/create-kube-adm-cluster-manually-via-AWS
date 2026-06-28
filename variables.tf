
variable "aws_region" {
  description = "AWS region for the kubeadm lab"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Local AWS CLI profile used by Terraform"
  type        = string
  default     = "kubeadm-lab"
}

variable "project_name" {
  description = "Project name used for tagging AWS resources"
  type        = string
  default     = "kubeadm-aws-cluster-lab"
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR format, used to restrict SSH and NodePort access"
  type        = string
}

variable "public_key_path" {
  description = "Path to the local SSH public key"
  type        = string
  default     = "./kubeadm-lab-key.pub"
}

variable "instance_plan" {
  description = "EC2 instance plan for the kubeadm cluster"

  type = map(object({
    instance_type = string
    disk_size     = number
    role          = string
  }))

  default = {
    "k8s-master" = {
      instance_type = "t3.medium"
      disk_size     = 25
      role          = "control-plane"
    }

    "k8s-worker-1" = {
      instance_type = "t3.small"
      disk_size     = 20
      role          = "worker"
    }

    "k8s-worker-2" = {
      instance_type = "t3.small"
      disk_size     = 20
      role          = "worker"
    }
  }
}
