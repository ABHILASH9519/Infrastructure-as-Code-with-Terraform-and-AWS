variable "name" {
  type        = string
  description = "Resource name prefix."
}
variable "vpc_cidr" {
  type        = string
  description = "IPv4 CIDR range for the VPC."
  default     = "10.20.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}
variable "public_subnet_cidrs" {
  type        = list(string)
  description = "One public subnet CIDR per configured availability zone."
  default     = ["10.20.1.0/24", "10.20.2.0/24"]

  validation {
    condition = length(var.public_subnet_cidrs) > 0 && alltrue([
      for cidr in var.public_subnet_cidrs :
      can(cidrnetmask(cidr)) && tonumber(split("/", cidr)[1]) > tonumber(split("/", var.vpc_cidr)[1]) && cidrcontains(var.vpc_cidr, cidrhost(cidr, 0))
    ])
    error_message = "public_subnet_cidrs must contain valid IPv4 networks whose network addresses are inside vpc_cidr."
  }
}
variable "private_subnet_cidrs" {
  type        = list(string)
  description = "One private subnet CIDR per configured availability zone."
  default     = ["10.20.11.0/24", "10.20.12.0/24"]

  validation {
    condition = length(var.private_subnet_cidrs) > 0 && alltrue([
      for cidr in var.private_subnet_cidrs :
      can(cidrnetmask(cidr)) && can(cidrcontains(var.vpc_cidr, cidrhost(cidr, 0))) && cidrcontains(var.vpc_cidr, cidrhost(cidr, 0))
    ])
    error_message = "private_subnet_cidrs must contain valid IPv4 networks whose network addresses are inside vpc_cidr."
  }
}
variable "availability_zones" {
  type        = list(string)
  description = "AZ for each public/private subnet index."

  validation {
    condition     = length(var.availability_zones) > 0 && length(var.availability_zones) == length(var.public_subnet_cidrs) && length(var.availability_zones) == length(var.private_subnet_cidrs)
    error_message = "availability_zones, public_subnet_cidrs and private_subnet_cidrs must have equal non-zero lengths."
  }
}
variable "tags" {
  type    = map(string)
  default = {}
}
