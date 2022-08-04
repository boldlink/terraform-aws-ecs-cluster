#### Complete example
resource "aws_cloudwatch_log_group" "this" {
  count = local.logging != "OVERRIDE" ? 0 : 1
  name  = "${local.name}-log-group"
}

module "kms_key" {
  source                  = "boldlink/kms/aws"
  description             = "A test kms key for ecs cluster"
  alias_name              = "alias/${local.name}-alias"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

module "cluster" {
  source = "../../"
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

  subnet_id = local.public_subnets
  vpc_id    = local.vpc_id
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
  availability_zones = [local.azs]
  max_size           = 2

  tags = local.tags
}
