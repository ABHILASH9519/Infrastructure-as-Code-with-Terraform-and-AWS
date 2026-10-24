variable "name" {
  type        = string
  description = "Resource name prefix."
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
  description = "AZ for each public/private subnet index."
}
variable "tags" {
  type    = map(string)
  default = {}
}