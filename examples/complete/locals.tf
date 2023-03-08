locals {
  subnet_az = [
    for az in data.aws_subnet.private : az.availability_zone
  ]

  subnet_id = [
    for s in data.aws_subnet.private : s.id
  ]

  private_subnets = local.subnet_id[0]
  azs             = local.subnet_az[0]
  vpc_id          = data.aws_vpc.supporting.id
  region          = data.aws_region.current.name
  partition       = data.aws_partition.current.partition
  account_id      = data.aws_caller_identity.current.account_id
  dns_suffix      = data.aws_partition.current.dns_suffix

  ecs_instance_userdata = <<USERDATA
  #!/bin/bash -x
  cat <<'EOF' >> /etc/ecs/ecs.config
  ECS_CLUSTER=${var.name}
  EOF
  USERDATA
}
