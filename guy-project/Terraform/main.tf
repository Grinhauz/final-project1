terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.83.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

}

# Generate an SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/key/builder_key.pem"
  file_permission = "0400"
}

# Create an AWS key pair using the public key
resource "aws_key_pair" "builder_key" {
  key_name   = "builder-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Output the necessary details
output "ssh_private_key_path" {
  value       = local_file.private_key.filename
  description = "Path to the generated private SSH key"
  sensitive   = true
}

output "ssh_key_name" {
  value       = aws_key_pair.builder_key.key_name
  description = "Name of the AWS SSH key pair"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "builder" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.builder_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  subnet_id              = data.aws_subnet.public.id

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  tags = {
    Name  = "builder"
    owner = "Guy"
  }
}

data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet"]
  }

  vpc_id = data.aws_vpc.this.id
}