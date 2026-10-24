output "instance_id" {
  value       = aws_instance.this.id
  description = "EC2 instance ID."
}
output "security_group_id" {
  value       = aws_security_group.this.id
  description = "Security group ID."
}