module "vpc" {
  source               = "boldlink/vpc/aws"
  version              = "2.0.3"
  name                 = var.name
  account              = local.account_id
  region               = local.region
  cidr_block           = var.cidr_block
  create_nat_gateway   = true
  nat_single_az        = true
  private_subnets      = local.private_subnets
  public_subnets       = local.public_subnets
  enable_dns_hostnames = true
  availability_zones   = local.azs
  other_tags           = var.tags
}
