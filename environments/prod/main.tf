provider "aws" {
  region = var.aws_region
  default_tags { tags = var.tags }
}
module "network" {
  source = "../../modules/network"
  name = "${var.project_name}-${var.environment}"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones = var.availability_zones
  tags = var.tags
}