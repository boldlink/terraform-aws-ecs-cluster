
variable "name" {
  description = "(Required) Name of the cluster (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
}

variable "configuration" {
  description = "(Optional) The execute command configuration for the cluster. Detailed below."
  type        = any
  default = {
    execute_command_configuration = {
      kms_key_id = null
      logging    = "NONE"
      log_configuration = {
        cloud_watch_encryption_enabled = false
        cloud_watch_log_group_name     = null
        s3_bucket_name                 = null
        s3_bucket_encryption_enabled   = false
        s3_key_prefix                  = null
      }
    }
  }
}

variable "container_insights" {
  description = "The value to assign to the setting. Value values are enabled and disabled."
  default     = "enabled"
  type        = string
}

variable "environment" {
  description = "Environment tag, e.g prod, test"
  default     = null
  type        = string
}

variable "other_tags" {
  description = "Any additional values for tags"
  default     = {}
  type        = map(string)
}
