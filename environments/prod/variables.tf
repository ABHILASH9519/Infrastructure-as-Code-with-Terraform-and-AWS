variable "project_name" { type = string, default = "tf-aws-platform" }
variable "environment" { type = string, default = "prod" }
variable "aws_region" { type = string, default = "ap-south-1" }
variable "vpc_cidr" { type = string, default = "10.30.0.0/16" }
variable "public_subnet_cidrs" { type = list(string), default = ["10.30.1.0/24", "10.30.2.0/24"] }
variable "private_subnet_cidrs" { type = list(string), default = ["10.30.11.0/24", "10.30.12.0/24"] }
variable "availability_zones" {
  type = list(string)
  description = "Must be valid in the selected region."
  default = ["ap-south-1a", "ap-south-1b"]
}
variable "tags" {
  type = map(string)
  default = { ManagedBy = "Terraform", Project = "terraform-aws-infrastructure", Environment = "prod" }
}