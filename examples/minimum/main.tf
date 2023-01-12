#### Minimum example
locals {
  name = "minimum-ecs-cluster-example"
  tags = {
    Environment        = "examples"
    Name               = local.name
    "user::CostCenter" = "terraform"
    department         = "operations"
    Project            = "ecs-security"
    Owner              = "hugo.almeida"
    InstanceScheduler  = true
    LayerName          = "c600-aws-ecs-cluster"
    LayerId            = "c600"
  }
}

module "minimum_cluster" {
  #checkov:skip=CKV_AWS_224:Ensure Cluster logging with CMK
  source = "../../"
  name   = local.name
  tags   = local.tags
}
