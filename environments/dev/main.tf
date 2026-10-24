provider "aws" {
  region = var.aws_region
  default_tags { tags = var.tags }
}

module "network" {
  source               = "../../modules/network"
  name                 = "${var.project_name}-${var.environment}"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  tags                 = var.tags
}

module "compute" {
  count  = var.enable_ec2 ? 1 : 0
  source = "../../modules/compute"

  name                  = "${var.project_name}-${var.environment}-app"
  ami_id                = var.ami_id
  subnet_id             = var.ec2_subnet_id != "" ? var.ec2_subnet_id : module.network.private_subnet_ids[0]
  instance_type         = var.instance_type
  allowed_ingress_cidrs = var.allowed_ingress_cidrs
  tags                  = var.tags
  depends_on            = [module.network]
}