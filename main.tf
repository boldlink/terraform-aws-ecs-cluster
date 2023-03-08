### ECS Cluster
resource "aws_ecs_cluster" "this" {
  name = var.name

  setting {
    name  = "containerInsights"
    value = var.container_insights
  }

  tags = var.tags
  dynamic "configuration" {
    for_each = length(keys(var.configuration)) > 0 ? [var.configuration] : []

    content {
      dynamic "execute_command_configuration" {
        for_each = try([configuration.value.execute_command_configuration], [])

        content {
          kms_key_id = var.kms_key_id == null ? aws_kms_key.main[0].key_id : var.kms_key_id
          logging    = lookup(execute_command_configuration.value, "logging", null)

          dynamic "log_configuration" {
            for_each = try([execute_command_configuration.value.log_configuration], [])

            content {
              cloud_watch_encryption_enabled = var.kms_key_id == null ? true : lookup(log_configuration.value, "cloud_watch_encryption_enabled", null)
              cloud_watch_log_group_name     = lookup(log_configuration.value, "cloud_watch_log_group_name", null)
              s3_bucket_name                 = lookup(log_configuration.value, "s3_bucket_name", null)
              s3_bucket_encryption_enabled   = var.kms_key_id == null ? true : lookup(log_configuration.value, "s3_bucket_encryption_enabled", null)
              s3_key_prefix                  = lookup(log_configuration.value, "s3_key_prefix", null)
            }
          }
        }
      }
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  count              = var.add_capacity_providers ? 1 : 0
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = var.capacity_providers

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategy
    content {
      base              = lookup(default_capacity_provider_strategy.value, "base", null)
      weight            = lookup(default_capacity_provider_strategy.value, "weight", null)
      capacity_provider = lookup(default_capacity_provider_strategy.value, "capacity_provider")
    }
  }
}


### KMS Key
resource "aws_kms_key" "main" {
  count                   = var.kms_key_id == null ? 1 : 0
  description             = "KMS key to encrypt the data between the local client and the container and cloudwatch logs."
  enable_key_rotation     = var.enable_key_rotation
  policy                  = local.kms_policy
  deletion_window_in_days = var.deletion_window_in_days
}
