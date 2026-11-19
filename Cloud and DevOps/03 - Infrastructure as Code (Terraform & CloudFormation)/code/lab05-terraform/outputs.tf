output "s3_bucket_name" {
  description = "The globally unique name of the created S3 bucket"
  value       = aws_s3_bucket.int378_storage.id
}

output "s3_bucket_arn" {
  description = "The ARN of the created S3 bucket"
  value       = aws_s3_bucket.int378_storage.arn
}

output "ec2_instance_id" {
  description = "ID of the launched EC2 instance"
  value       = aws_instance.int378_vm.id
}

output "ec2_public_ip" {
  description = "Public IPv4 address of the web server"
  value       = aws_instance.int378_vm.public_ip
}

output "web_url" {
  description = "Public HTTP URL of the deployed web application"
  value       = "http://${aws_instance.int378_vm.public_ip}"
}
