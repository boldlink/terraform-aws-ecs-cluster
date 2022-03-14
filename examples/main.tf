
locals {
  name           = "Sample-Cluster"
  logging        = "OVERRIDE" #Valid values are NONE, DEFAULT, and OVERRIDE.
  create_kms_key = false
}

resource "aws_cloudwatch_log_group" "this" {
  count = local.logging != "OVERRIDE" ? 0 : 1
  name  = "${local.name}-log-group"

}

module "kms_key" {
  count               = local.create_kms_key ? 1 : 0
  source              = "boldlink/kms-key/aws"
  description         = "A test kms key for ecs cluster"
  name                = "${local.name}-key"
  alias_name          = "alias/my-key-alias"
  enable_key_rotation = true
}

module "cluster" {
  source  = "boldlink/ecs-cluster/aws"
  version = "1.0.0"
  name    = local.name
  configuration = {
    execute_command_configuration = {
      kms_key_id = try(module.kms_key[0].key_id, null)
      log_configuration = {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = try(aws_cloudwatch_log_group.this[0].name, null)
        s3_bucket_encryption_enabled   = false
      }
      logging = local.logging
    }
  }
}

output "cluster" {
  value = [
    module.cluster,
    module.kms_key,
  ]
}
