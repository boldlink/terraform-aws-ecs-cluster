
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

variable "metadata_options" {
  type        = map(string)
  description = "Customize the metadata options of the instance"
  default     = {}
}

variable "tags" {
  description = "Key-value map of resource tags."
  default     = {}
  type        = map(string)
}

# Capacity Providers

variable "add_capacity_providers" {
  description = "Whether or not to deploy aws_cluster_capacity_providers resource"
  type        = bool
  default     = false
}

variable "capacity_providers" {
  description = "(Optional) Set of names of one or more capacity providers to associate with the cluster. Valid values also include FARGATE and FARGATE_SPOT."
  type        = list(string)
  default     = ["FARGATE"]
}

variable "default_capacity_provider_strategy" {
  description = "(Optional) Set of capacity provider strategies to use by default for the cluster."
  type        = list(map(any))
  default     = []
}

# Security Group

variable "vpc_id" {
  description = "(Optional, Forces new resource) VPC ID"
  type        = string
  default     = null
}

variable "ingress_rules" {
  description = "(Optional) Ingress rules to add to the security group"
  type        = any
  default     = {}
}
variable "egress_rules" {
  description = "(Optional) Egress rules to add to the security group"
  type        = any
  default     = {}
}

variable "create_security_group" {
  description = "Whether to create a Security Group for ECS cluster."
  default     = true
  type        = bool
}

variable "subnet_id" {
  description = "The subnet ID to launch the instances in"
  type        = string
  default     = null
}

# Launch template

variable "create_ec2_instance" {
  description = "Whether or not to create a cluster ec2 instance(s)"
  type        = bool
  default     = false
}

variable "image_id" {
  description = "(Optional) The AMI from which to launch the instance."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "(Optional) The type of the instance."
  type        = string
  default     = null
}

variable "key_name" {
  description = "(Optional) The key name to use for the instance."
  type        = string
  default     = null
}
variable "user_data" {
  description = "(Optional) The base64-encoded user data to provide when launching the instance."
  type        = string
  default     = null
}

variable "monitoring_enabled" {
  description = "(Optional) The monitoring option for the instance."
  type        = bool
  default     = false
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with the network interface. Boolean value."
  type        = bool
  default     = true
}

variable "delete_on_termination" {
  description = "Whether the network interface should be destroyed on instance termination. Defaults to false if not set."
  type        = bool
  default     = true
}

# Autoscaling Group
variable "availability_zones" {
  description = "(Optional) A list of one or more availability zones for the group. Used for EC2-Classic, attaching a network interface via id from a launch template"
  type        = list(string)
  default     = []
}

variable "desired_capacity" {
  description = "(Optional) The number of Amazon EC2 instances that should be running in the group."
  type        = number
  default     = 1
}

variable "min_size" {
  description = "(Required) The minimum size of the Auto Scaling Group."
  type        = number
  default     = 1
}

variable "max_size" {
  description = " (Required) The maximum size of the Auto Scaling Group"
  type        = number
  default     = 10
}

variable "block_device_mappings" {
  description = "(Optional) Specify volumes to attach to the instance besides the volumes specified by the AMI. "
  type        = list(any)
  default     = []
}

### KMS Key
variable "kms_key_id" {
  description = "(Optional) The AWS Key Management Service key ID to encrypt the data between the local client and the container."
  type        = string
  default     = null
}

variable "enable_key_rotation" {
  description = "(Optional) Specifies whether key rotation is enabled. Defaults to false."
  type        = bool
  default     = false
}

variable "key_description" {
  description = "The description of the key as viewed in AWS console."
  type = string
  default = null
}

variable "deletion_window_in_days" {
  description = " (Optional) The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30."
  type        = number
  default     = 30
}
