data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "kubeadm_lab" {
  key_name   = "${var.project_name}-key"
  public_key = file(var.public_key_path)

  tags = {
    Name    = "${var.project_name}-key"
    Project = var.project_name
  }
}

resource "aws_instance" "nodes" {
  for_each = var.instance_plan

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = each.value.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.k8s.id]
  key_name                    = aws_key_pair.kubeadm_lab.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = each.value.disk_size
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name    = each.key
    Role    = each.value.role
    Project = var.project_name
  }
}
