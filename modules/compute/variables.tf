variable "name" { type = string }
variable "ami_id" { type = string, description = "Region-compatible AMI ID." }
variable "subnet_id" { type = string, description = "Subnet in which to place the instance." }
variable "instance_type" { type = string, default = "t3.micro" }
variable "allowed_ingress_cidrs" { type = list(string), default = [] }
variable "tags" { type = map(string), default = {} }