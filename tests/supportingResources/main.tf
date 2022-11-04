module "ecs_vpc" {
  source             = "boldlink/vpc/aws"
  version            = "2.0.3"
  name               = local.name
  account            = local.account_id
  region             = local.region
  cidr_block         = local.cidr_block
  create_nat_gateway = true
  nat_single_az      = true
  private_subnets    = local.private_subnets
  availability_zones = local.azs
  tag_env            = local.tag_env

  other_tags = {
    "user::CostCenter" = "terraform"
    department         = "operations"
    instance-scheduler = true
    LayerName          = "c600-aws-ecs-cluster"
    LayerId            = "c600"
  }
}
