variable "project_name" {
  type    = string
  default = "tf-aws-platform"
}
variable "environment" {
  type    = string
  default = "dev"
}
variable "aws_region" {
  type    = string
  default = "ap-south-1"
}
variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}
variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.11.0/24", "10.20.12.0/24"]
}
variable "availability_zones" {
  type        = list(string)
  description = "Must be valid in the selected region and match both subnet lists."
  default     = ["ap-south-1a", "ap-south-1b"]

  validation {
    condition     = length(var.availability_zones) > 0 && length(var.availability_zones) == length(var.public_subnet_cidrs) && length(var.availability_zones) == length(var.private_subnet_cidrs)
    error_message = "Provide one availability zone for every public and private subnet."
  }
}
variable "enable_ec2" {
  type        = bool
  description = "Opt in to EC2 creation; disabled by default."
  default     = false
}
variable "ami_id" {
  type        = string
  description = "Region-compatible AMI ID. Required when enable_ec2 is true."
  default     = ""

  validation {
    condition     = !var.enable_ec2 || can(regex("^ami-[0-9a-fA-F]+$", var.ami_id))
    error_message = "When enable_ec2 is true, ami_id must be a valid-looking AMI ID for the selected region."
  }
}
variable "ec2_subnet_id" {
  type        = string
  description = "Optional subnet override; otherwise first private subnet."
  default     = ""
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "allowed_ingress_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to access TCP 443; empty by default."
  default     = []

  validation {
    condition     = alltrue([for cidr in var.allowed_ingress_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Every allowed_ingress_cidrs entry must be a valid IPv4 CIDR."
  }
}
variable "tags" {
  type = map(string)
  default = {
    ManagedBy   = "Terraform"
    Project     = "terraform-aws-infrastructure"
    Environment = "dev"
  }
}
