variable "name" {
  description = " Name of the cluster (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
  default     = "complete-ecs-cluster-example"
}
variable "supporting_resources_name" {
  description = " Name of the supporting resources name tag"
  type        = string
  default     = "terraform-aws-ecs-cluster"
}

variable "retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  type        = number
  default     = 7
}

variable "create_ec2_instance" {
  description = "Whether or not to create a cluster ec2 instance(s)"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "(Optional) The type of the instance."
  type        = string
  default     = "t2.micro"
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with the network interface. Boolean value."
  type        = bool
  default     = false
}

variable "max_size" {
  description = " (Required) The maximum size of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "logging" {
  description = "The log setting to use for redirecting logs for your execute command results. Valid values are NONE, DEFAULT, and OVERRIDE."
  type        = string
  default     = "OVERRIDE"
}

variable "block_device_mappings" {
  description = "(Optional) Specify volumes to attach to the instance besides the volumes specified by the AMI. "
  type        = list(any)
  default = [
    {
      device_name = "/dev/xvda"
      ebs = {
        delete_on_termination = true
        volume_size           = 20
        volume_type           = "gp2"
        encrypted             = true
      }
    },
    {
      device_name = "/dev/xvdcz"
      ebs = {
        delete_on_termination = true
        volume_size           = 22
        volume_type           = "gp2"
        encrypted             = true
      }
    }
  ]
}

variable "key_description" {
  description = "The description of the key as viewed in AWS console."
  type        = string
  default     = "KMS key to encrypt the data between the local client and the container and cloudwatch logs."
}

variable "tags" {
  description = " A map of tags to assign to the object. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default = {
    Environment        = "example"
    "user::CostCenter" = "terraform-registry"
    Department         = "DevOps"
    InstanceScheduler  = true
    Project            = "Examples"
    Owner              = "Boldlink"
    LayerName          = "Example"
    LayerId            = "Example"
  }
}

