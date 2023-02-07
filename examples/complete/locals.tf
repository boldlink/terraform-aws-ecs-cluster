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
  region                    = data.aws_region.current.name
  partition                 = data.aws_partition.current.partition
  account_id                = data.aws_caller_identity.current.account_id
  dns_suffix                = data.aws_partition.current.dns_suffix

  kms_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "Enable IAM User Permissions"
          Effect = "Allow"
          Principal = {
            "AWS" = ["arn:${local.partition}:iam::${local.account_id}:root"]
          }
          Action   = ["kms:*"]
          Resource = ["*"]
        },
        {
          Sid = "AllowCloudWatchLogs"
          Action = [
            "kms:Encrypt*",
            "kms:Decrypt*",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Describe*"
          ]
          Effect = "Allow"
          Principal = {
            Service = ["logs.${local.region}.${local.dns_suffix}"]
          }
          Resource = ["*"]
          Condition = {
            ArnLike = {
              "kms:EncryptionContext:aws:logs:arn" = ["arn:${local.partition}:logs:${local.region}:${local.account_id}:log-group:${local.name}-log-group"]
            }
          }
        }
      ]
    }
  )

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

  logging               = "OVERRIDE" #Valid values are NONE, DEFAULT, and OVERRIDE.
  ecs_instance_userdata = <<USERDATA
  #!/bin/bash -x
  cat <<'EOF' >> /etc/ecs/ecs.config
  ECS_CLUSTER=${local.name}
  EOF
  USERDATA
}
