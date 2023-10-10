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
  default     = "t3.medium"
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

variable "create_kms_key" {
  description = "Whether or not to create a kms key with this module"
  type        = bool
  default     = true
}

variable "monitoring_enabled" {
  description = "(Optional) The monitoring option for the instance."
  type        = bool
  default     = true
}

# ECS Service

variable "image" {
  type        = string
  description = "Name of image to pull from dockerhub"
  default     = "boldlink/flaskapp:latest"
}

variable "cpu" {
  type        = number
  description = "The number of cpu units to allocate"
  default     = 10
}

variable "memory" {
  type        = number
  description = "The size of memory to allocate in MiBs"
  default     = 512
}

variable "essential" {
  type        = bool
  description = "Whether this container is essential"
  default     = true
}

variable "containerport" {
  type        = number
  description = "Specify container port"
  default     = 5000
}

variable "hostport" {
  type        = number
  description = "Specify host port"
  default     = 5000
}

variable "network_mode" {
  type        = string
  description = "Docker networking mode to use for the containers in the task. Valid values are none, bridge, awsvpc, and host."
  default     = "bridge"
}

variable "service_ingress_rules" {
  description = "Ingress rules to add to the service security group."
  type        = list(any)
  default = [
    {
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      description = "Allow traffic on port 5000. The app is configured to use this port"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "launch_type" {
  default     = "EC2"
  description = "Launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL. Defaults to EC2."
  type        = string
}

variable "requires_compatibilities" {
  description = "Set of launch types required by the task. The valid values are EC2 and FARGATE."
  type        = list(string)
  default     = []
}

variable "install_ssm_agent" {
  type        = bool
  description = "Whether to install ssm agent"
  default     = true
}
