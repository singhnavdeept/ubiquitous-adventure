variable "aws_region" {
  description = "The target AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type (Free tier eligible)"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Deployment lifecycle stage"
  type        = string
  default     = "development"
}
