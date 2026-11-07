variable "name" {
  type = string
}
variable "ami_id" {
  type        = string
  description = "Region-compatible AMI ID."

  validation {
    condition     = can(regex("^ami-[0-9a-f]+$", var.ami_id))
    error_message = "ami_id must use the AWS AMI identifier format."
  }
}
variable "subnet_id" {
  type        = string
  description = "Subnet in which to place the instance."
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "allowed_ingress_cidrs" {
  type        = list(string)
  description = "IPv4 CIDR ranges permitted to reach HTTPS."

  validation {
    condition     = alltrue([for cidr in var.allowed_ingress_cidrs : can(cidrnetmask(cidr))])
    error_message = "Every allowed_ingress_cidrs entry must be a valid IPv4 CIDR block."
  }

  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
