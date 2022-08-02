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
          kms_key_id = lookup(execute_command_configuration.value, "kms_key_id", null)
          logging    = lookup(execute_command_configuration.value, "logging", null)

          dynamic "log_configuration" {
            for_each = try([execute_command_configuration.value.log_configuration], [])

            content {
              cloud_watch_encryption_enabled = lookup(log_configuration.value, "cloud_watch_encryption_enabled", null)
              cloud_watch_log_group_name     = lookup(log_configuration.value, "cloud_watch_log_group_name", null)
              s3_bucket_name                 = lookup(log_configuration.value, "s3_bucket_name", null)
              s3_bucket_encryption_enabled   = lookup(log_configuration.value, "s3_bucket_encryption_enabled", null)
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
