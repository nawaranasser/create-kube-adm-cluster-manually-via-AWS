
resource "aws_security_group" "k8s" {
  name        = "${var.project_name}-sg"
  description = "Security group for kubeadm lab cluster"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name    = "${var.project_name}-sg"
    Project = var.project_name
  }
}

resource "aws_security_group_rule" "ssh_from_my_ip" {
  type              = "ingress"
  description       = "SSH from my public IP"
  security_group_id = aws_security_group.k8s.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [var.my_ip_cidr]
}

resource "aws_security_group_rule" "nodeport_from_my_ip" {
  type              = "ingress"
  description       = "NodePort range from my public IP for testing"
  security_group_id = aws_security_group.k8s.id

  from_port   = 30000
  to_port     = 32767
  protocol    = "tcp"
  cidr_blocks = [var.my_ip_cidr]
}

resource "aws_security_group_rule" "all_internal" {
  type              = "ingress"
  description       = "Allow all traffic between Kubernetes nodes"
  security_group_id = aws_security_group.k8s.id

  from_port = 0
  to_port   = 0
  protocol  = "-1"
  self      = true
}

resource "aws_security_group_rule" "all_outbound" {
  type              = "egress"
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.k8s.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
