#### Complete example
resource "aws_cloudwatch_log_group" "this" {
  count             = var.logging != "OVERRIDE" ? 0 : 1
  name              = local.log_group_name
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
  subnet_id           = local.private_subnets[0]
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
  block_device_mappings       = local.block_device_mappings
  image_id                    = data.aws_ami.amazon_ecs.image_id
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  install_ssm_agent           = var.install_ssm_agent
  extra_script                = local.ecs_instance_userdata
  availability_zones          = [local.azs]
  max_size                    = var.max_size
  monitoring_enabled          = var.monitoring_enabled
  metadata_options = {
    http_tokens = "required"
  }
  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}


module "ecs_service" {
  #checkov:skip=CKV_AWS_290: "Ensure IAM policies does not allow write access without constraints"
  #checkov:skip=CKV_AWS_355: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
  source                     = "boldlink/ecs-service/aws"
  version                    = "1.5.3"
  name                       = "${var.name}-service"
  family                     = "${var.name}-task-definition"
  network_mode               = var.network_mode
  cluster                    = module.cluster.arn
  vpc_id                     = local.vpc_id
  enable_execute_command     = true
  task_role_policy           = data.aws_iam_policy_document.ecs_assume_role_policy.json
  task_execution_role        = data.aws_iam_policy_document.ecs_assume_role_policy.json
  task_execution_role_policy = local.task_execution_role_policy_doc
  container_definitions      = local.default_container_definitions
  tags                       = local.tags
  service_ingress_rules      = var.service_ingress_rules
  launch_type                = var.launch_type
  requires_compatibilities   = var.requires_compatibilities

  network_configuration = {
    subnets = local.private_subnets
  }

  depends_on = [module.cluster]
}

resource "aws_iam_role_policy" "task_role_policy" {
  #checkov:skip=CKV_AWS_290: "Ensure IAM policies does not allow write access without constraints"
  #checkov:skip=CKV_AWS_355: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
  name       = "${var.name}-service-ecs-task-role-policy"
  role       = "${var.name}-service-ecs-task-role"
  policy     = data.aws_iam_policy_document.ecs_task_policy.json
  depends_on = [module.ecs_service]
}


#### example that logs to s3 and has capacity provider configuratio

module "cluster_bucket" {
  count         = var.logging != "OVERRIDE" ? 0 : 1
  source        = "boldlink/s3/aws"
  version       = "2.3.1"
  bucket        = "${var.name}-with-s3"
  force_destroy = true
  tags          = merge({ "Name" = "${var.name}-with-s3" }, var.tags)
}

module "log_to_s3" {
  source = "../../"
  name   = "${var.name}-with-s3"
  configuration = {
    execute_command_configuration = {
      log_configuration = {
        s3_bucket_name = try(module.cluster_bucket[0].id, null)
        # Make sure you grant ecs task role the necessary permissions to put logs to s3: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html
      }
      logging = var.logging
    }
  }
  create_kms_key         = var.create_kms_key
  add_capacity_providers = true
  capacity_providers     = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy = {
    default = {
      base              = 1
      weight            = 100
      capacity_provider = "FARGATE_SPOT"
    }
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}
