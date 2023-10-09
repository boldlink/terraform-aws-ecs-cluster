#### Complete example

resource "aws_cloudwatch_log_group" "this" {
  count             = var.logging != "OVERRIDE" ? 0 : 1
  name              = "${var.name}-log-group"
  retention_in_days = var.retention_in_days
  kms_key_id        = module.cluster.key_arn[0]
}

module "cluster" {
  source = "../../"
  name   = var.name
  configuration = {
    execute_command_configuration = {
      log_configuration = {
        cloud_watch_log_group_name = try(aws_cloudwatch_log_group.this[0].name, null)
      }
      logging = var.logging
    }
  }
  create_kms_key      = var.create_kms_key
  key_description     = var.key_description
  create_ec2_instance = var.create_ec2_instance
  subnet_id           = local.private_subnets
  vpc_id              = local.vpc_id
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
  block_device_mappings       = var.block_device_mappings
  image_id                    = data.aws_ami.amazon_ecs.image_id
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  extra_script                = local.ecs_instance_userdata
  availability_zones          = [local.azs]
  max_size                    = var.max_size
  monitoring_enabled          = var.monitoring_enabled
  metadata_options = {
    http_endpoint = "disabled"
  }
  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}
