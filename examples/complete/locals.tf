locals {
  subnet_az = [
    for az in data.aws_subnet.private : az.availability_zone
  ]

  subnet_id = [
    for i in data.aws_subnet.private : i.id
  ]

  name                      = "complete-ecs-cluster-example"
  private_subnets           = local.subnet_id[0]
  azs                       = local.subnet_az[0]
  supporting_resources_name = "terraform-aws-ecs-cluster"
  vpc_id                    = data.aws_vpc.supporting.id

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

  logging               = "OVERRIDE" #Valid values are NONE, DEFAULT, and OVERRIDE.
  ecs_instance_userdata = <<USERDATA
  #!/bin/bash -x
  cat <<'EOF' >> /etc/ecs/ecs.config
  ECS_CLUSTER=${local.name}
  EOF
  USERDATA
}
