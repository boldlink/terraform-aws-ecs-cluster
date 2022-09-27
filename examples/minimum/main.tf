#### Minimum example
locals {
  name = "minimum-ecs-cluster-example"
  tags = {
    Environment        = "examples"
    Name               = local.name
    "user::CostCenter" = "terraform-registry"
  }
}

module "minimum_cluster" {
  source = "../../"
  name   = local.name
  tags   = local.tags
}
