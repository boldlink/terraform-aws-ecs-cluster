
locals {
  name                  = "Sample-Cluster3"
  logging               = "OVERRIDE" #Valid values are NONE, DEFAULT, and OVERRIDE.
  create_kms_key        = false
  ecs_instance_userdata = <<USERDATA
  #!/bin/bash -x
  cat <<'EOF' >> /etc/ecs/ecs.config
  ECS_CLUSTER=Sample-Cluster3
  EOF
  USERDATA
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
  source = "./../"
  name   = local.name
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

  create_ec2_instance = true


  #create_security_group = false
  ingress_rules = {
    default = {
      from_port   = 0
      to_port     = 0
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
  egress_rules = {
    default = {
      from_port   = 0
      to_port     = 0
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  image_id           = data.aws_ami.amazon_ecs.image_id
  instance_type      = "t2.micro"
  user_data          = base64encode(local.ecs_instance_userdata)
  device_name        = "/dev/xvda"
  availability_zones = data.aws_availability_zones.available.names
  max_size           = 2
}

output "cluster" {
  value = [
    module.cluster,
  ]
}
