#### Minimum example
locals {
  name = "minimum-ecs-cluster-example"
  tags = {
    Environment        = "examples"
    Name               = local.name
    "user::CostCenter" = "terraform"
    department         = "operations"
    instance-scheduler = true
    LayerName          = "c600-aws-ecs-cluster"
    LayerId            = "c600"
  }
}

module "minimum_cluster" {
  source = "../../"
  name   = local.name
  tags   = local.tags
}
