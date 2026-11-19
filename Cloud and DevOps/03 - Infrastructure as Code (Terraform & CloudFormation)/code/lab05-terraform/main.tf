terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Generate a random suffix for globally unique S3 bucket naming
resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}

# 1. Secure Amazon S3 Bucket
resource "aws_s3_bucket" "int378_storage" {
  bucket        = "int378-storage-${random_string.bucket_suffix.result}"
  force_destroy = true # Allows clean destruction during student teardown

  tags = {
    Name        = "INT378-Storage-Bucket"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Enable S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "storage_versioning" {
  bucket = aws_s3_bucket.int378_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enforce Server-Side Encryption (AES256)
resource "aws_s3_bucket_server_side_encryption_configuration" "storage_crypto" {
  bucket = aws_s3_bucket.int378_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access by default (Security Best Practice)
resource "aws_s3_bucket_public_access_block" "storage_public_block" {
  bucket = aws_s3_bucket.int378_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Query the latest Amazon Linux 2023 AMI dynamically
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Query default VPC for simple, zero-cost student deployment
data "aws_vpc" "default" {
  default = true
}

# Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "int378-tf-ec2-sg"
  description = "Allow inbound HTTP and SSH traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "int378-tf-sg"
    Environment = var.environment
  }
}

# 2. EC2 Virtual Machine
resource "aws_instance" "int378_vm" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "<h1>INT378 Terraform Provisioned Instance</h1><p>Environment: ${var.environment}</p>" > /var/www/html/index.html
              EOF

  tags = {
    Name        = "int378-tf-instance"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
