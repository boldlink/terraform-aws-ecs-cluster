#### Minimum example
locals {
  name = "minimum-ecs-cluster-example"
  tags = {
    Environment        = "example"
    Name               = local.name
    "user::CostCenter" = "terraform"
    department         = "DevOps"
    Project            = "Examples"
    Owner              = "Boldlink"
    InstanceScheduler  = true
    LayerName          = "cExample"
    LayerId            = "cExample"
  }
}

module "minimum_cluster" {
  #checkov:skip=CKV_AWS_224:Ensure Cluster logging with CMK
  source = "../../"
  name   = local.name
  tags   = local.tags
}
