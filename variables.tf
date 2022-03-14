
variable "name" {
  description = "(Required) Name of the cluster (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
}

variable "configuration" {
  description = "(Optional) The execute command configuration for the cluster. Detailed below."
  type        = any
  default     = {}
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
