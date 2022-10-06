locals {
  subnet_az = [
    for az in data.aws_subnet.public : az.availability_zone
  ]

  subnet_id = [
    for i in data.aws_subnet.public : i.id
  ]

  name                      = "complete-ecs-cluster-example"
  public_subnets            = local.subnet_id[0]
  azs                       = local.subnet_az[0]
  supporting_resources_name = "terraform-aws-ecs-cluster"
  vpc_id                    = data.aws_vpc.supporting.id

  tags = {
    Environment        = "examples"
    Name               = local.name
    "user::CostCenter" = "terraform-registry"
  }

  logging               = "OVERRIDE" #Valid values are NONE, DEFAULT, and OVERRIDE.
  ecs_instance_userdata = <<USERDATA
  #!/bin/bash -x
  cat <<'EOF' >> /etc/ecs/ecs.config
  ECS_CLUSTER=${local.name}
  EOF
  USERDATA
}
