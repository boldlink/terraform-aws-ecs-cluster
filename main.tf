
resource "aws_ecs_cluster" "main" {
  name = var.name

  dynamic "configuration" {
    for_each = var.configuration == null ? [] : [var.configuration]
    content {
      dynamic "execute_command_configuration" {
        for_each = try([configuration.value.execute_command_configuration], [])
        content {
          kms_key_id = execute_command_configuration.value.logging
          logging    = execute_command_configuration.value.logging
          dynamic "log_configuration" {
            for_each = execute_command_configuration.value.logging == "OVERRIDE" ? [execute_command_configuration.value.log_configuration] : []
            content {
              cloud_watch_encryption_enabled = lookup(log_configuration.value, "cloud_watch_encryption_enabled", false)
              cloud_watch_log_group_name     = lookup(log_configuration.value, "cloud_watch_log_group_name", null)
              s3_bucket_name                 = lookup(log_configuration.value, "s3_bucket_name", null)
              s3_bucket_encryption_enabled   = lookup(log_configuration.value, "s3_bucket_encryption_enabled", false)
              s3_key_prefix                  = lookup(log_configuration.value, "s3_key_prefix", null)
            }
          }
        }
      }
    }
  }

  setting {
    name  = "containerInsights"
    value = var.container_insights
  }

  tags = merge(
    {
      "Name"        = "${var.name}_tag"
      "Environment" = var.environment
    },
    var.other_tags,
  )

}
