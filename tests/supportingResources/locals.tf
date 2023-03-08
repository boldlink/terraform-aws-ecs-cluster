locals {
  private_subnets = [cidrsubnet(var.cidr_block, 8, 1), cidrsubnet(var.cidr_block, 8, 2), cidrsubnet(var.cidr_block, 8, 3)]
  public_subnets  = [cidrsubnet(var.cidr_block, 8, 4), cidrsubnet(var.cidr_block, 8, 5), cidrsubnet(var.cidr_block, 8, 6)]
  region          = data.aws_region.current.id
  account_id      = data.aws_caller_identity.current.id
  azs             = flatten(data.aws_availability_zones.available.names)
}
