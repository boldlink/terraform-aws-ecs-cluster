#### Complete example

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "random_id" "cluster_suffix" {
  byte_length = 3
}


resource "aws_cloudwatch_log_group" "this" {
  count             = var.logging != "OVERRIDE" ? 0 : 1
  name              = local.log_group_name
  retention_in_days = var.retention_in_days
  # kms_key_id        = module.cluster.key_arn[0]
}

module "cluster" {
  source = "../../"
  name   = "${var.name}-main-${random_id.cluster_suffix.hex}" # Unique name for the cluster, avoid IAM names conflicts
  configuration = {
    execute_command_configuration = {
      log_configuration = {
        cloud_watch_log_group_name     = try(aws_cloudwatch_log_group.this[0].name, null)
        cloud_watch_encryption_enabled = var.create_kms_key
        s3_key_prefix                  = "ecs-exec-logs/"
      }
      logging = var.logging
    }
  }
  container_insights      = var.container_insights
  create_kms_key          = var.create_kms_key
  enable_key_rotation     = var.enable_key_rotation
  deletion_window_in_days = var.deletion_window_in_days
  key_description         = var.key_description
  create_ec2_instance     = var.create_ec2_instance
  subnet_id               = local.private_subnets[0]
  vpc_id                  = local.vpc_id
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
  block_device_mappings           = local.block_device_mappings
  enable_default_ebs_configuration = false
  image_id                        = data.aws_ami.amazon_ecs.image_id
  instance_type                   = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  delete_on_termination       = var.delete_on_termination
  install_ssm_agent           = var.install_ssm_agent
  extra_script                = local.ecs_instance_userdata
  availability_zones          = [local.azs]
  desired_capacity            = var.desired_capacity
  min_size                    = var.min_size
  max_size                    = var.max_size
  launch_template_version     = var.launch_template_version
  monitoring_enabled          = var.monitoring_enabled
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    http_protocol_ipv6          = "disabled"
    instance_metadata_tags      = "enabled"
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
  source                            = "boldlink/ecs-service/aws"
  version                           = "1.12.2"
  name                              = "${var.name}-service"
  family                            = "${var.name}-task-definition"
  network_mode                      = var.network_mode
  cluster                           = module.cluster.arn
  vpc_id                            = local.vpc_id
  enable_execute_command            = true
  task_assume_role_policy           = data.aws_iam_policy_document.ecs_assume_role_policy.json
  task_role_policy                  = data.aws_iam_policy_document.ecs_task_policy.json
  task_execution_assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
  task_execution_role_policy        = local.task_execution_role_policy_doc
  container_definitions             = local.default_container_definitions
  tags                              = local.tags
  service_ingress_rules             = var.service_ingress_rules
  launch_type                       = var.launch_type
  requires_compatibilities          = var.requires_compatibilities

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
  version       = "2.5.1"
  bucket        = "${var.name}-s3-logs-${random_id.bucket_suffix.hex}"
  force_destroy = true
  tags          = merge({ "Name" = "${var.name}-s3-logs" }, var.tags)
}

module "log_to_s3" {
  source = "../../"
  name   = "${var.name}-s3-logs-${random_id.cluster_suffix.hex}"
  configuration = {
    execute_command_configuration = {
      log_configuration = {
        s3_bucket_name               = try(module.cluster_bucket[0].id, null)
        s3_bucket_encryption_enabled = var.create_kms_key
        s3_key_prefix                = "ecs-exec-s3-logs/"
        # Make sure you grant ecs task role the necessary permissions to put logs to s3: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html
      }
      logging = var.logging
    }
  }
  container_insights     = "disabled"
  create_kms_key         = var.create_kms_key
  add_capacity_providers = true
  capacity_providers     = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy = {
    fargate = {
      base              = 0
      weight            = 50
      capacity_provider = "FARGATE"
    }
    fargate_spot = {
      base              = 1
      weight            = 100
      capacity_provider = "FARGATE_SPOT"
    }
  }

  tags = merge(
    {
      Name = "${var.name}-with-s3"
    },
    var.tags
  )
}

#### Example with DEFAULT logging and custom user_data
module "cluster_default_logging" {
  source = "../../"
  name   = "${var.name}-default-logs-${random_id.cluster_suffix.hex}"
  configuration = {
    execute_command_configuration = {
      logging = "DEFAULT"
    }
  }
  container_insights  = "disabled"
  create_ec2_instance = var.create_ec2_instance
  create_kms_key      = false
  subnet_id           = local.private_subnets[0]
  vpc_id              = local.vpc_id
  image_id            = data.aws_ami.amazon_ecs.image_id
  instance_type       = var.instance_type
  user_data           = base64encode(local.custom_user_data)
  availability_zones  = [local.azs]
  desired_capacity    = 1
  min_size            = 1
  max_size            = 3
  tags = merge(
    {
      Name = "${var.name}-default"
    },
    var.tags
  )
}

#### Example with NONE logging and existing security group
module "cluster_no_logging" {
  source = "../../"
  name   = "${var.name}-no-logs-${random_id.cluster_suffix.hex}"
  configuration = {
    execute_command_configuration = {
      logging = "NONE"
    }
  }
  create_security_group = false
  create_ec2_instance   = false
  tags = merge(
    {
      Name = "${var.name}-no-log"
    },
    var.tags
  )
}

#### Example testing existing KMS key
resource "aws_kms_key" "existing" {
  description             = "Existing KMS key for testing"
  deletion_window_in_days = 10
  enable_key_rotation     = false
}

module "cluster_existing_kms" {
  source = "../../"
  name   = "${var.name}-external-kms-${random_id.cluster_suffix.hex}"
  configuration = {
    execute_command_configuration = {
      logging = "DEFAULT"
    }
  }
  create_kms_key = false
  kms_key_id     = aws_kms_key.existing.key_id
  tags = merge(
    {
      Name = "${var.name}-ext-kms"
    },
    var.tags
  )
}

#### EC2 Capacity Provider with managed scaling
resource "aws_ecs_capacity_provider" "ec2" {
  count = var.create_ec2_instance ? 1 : 0
  name  = "${var.name}-ec2-cp-${random_id.cluster_suffix.hex}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = module.cluster_ec2_capacity.autoscaling_group_arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 5
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 80
      instance_warmup_period    = 300
    }
  }

  tags = var.tags
}

module "cluster_ec2_capacity" {
  source = "../../"
  name   = "${var.name}-ec2-cluster-${random_id.cluster_suffix.hex}"

  create_ec2_instance    = var.create_ec2_instance
  add_capacity_providers = var.create_ec2_instance
  capacity_providers     = var.create_ec2_instance ? [aws_ecs_capacity_provider.ec2[0].name] : ["FARGATE"]
  enable_managed_scaling = var.enable_managed_scaling

  default_capacity_provider_strategy = var.create_ec2_instance ? {
    ec2_only = {
      base              = 0
      weight            = 100
      capacity_provider = aws_ecs_capacity_provider.ec2[0].name
    }
  } : {}

  subnet_id                       = local.private_subnets[0]
  vpc_id                          = local.vpc_id
  image_id                        = data.aws_ami.amazon_ecs.image_id
  instance_type                   = var.instance_type
  availability_zones              = [local.azs]
  desired_capacity                = 2
  min_size                        = 1
  max_size                        = 5
  enable_default_ebs_configuration = false

  tags = merge(
    {
      Name = "${var.name}-ec2-cluster-${random_id.cluster_suffix.hex}"
    },
    var.tags
  )
}

#### EC2 only capacity provider (renamed from mixed for clarity)
resource "aws_ecs_capacity_provider" "mixed" {
  count = var.create_ec2_instance ? 1 : 0
  name  = "${var.name}-mixed-cp-${random_id.cluster_suffix.hex}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = module.cluster_mixed_capacity.autoscaling_group_arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }

  tags = var.tags
}

module "cluster_mixed_capacity" {
  source = "../../"
  name   = "${var.name}-mixed-cluster-${random_id.cluster_suffix.hex}"

  create_ec2_instance    = var.create_ec2_instance
  add_capacity_providers = true
  capacity_providers = var.create_ec2_instance ? [
    aws_ecs_capacity_provider.mixed[0].name
  ] : ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy = var.create_ec2_instance ? {
    ec2_only = {
      base              = 1
      weight            = 100
      capacity_provider = aws_ecs_capacity_provider.mixed[0].name
    }
    } : {
    fargate = {
      base              = 1
      weight            = 1
      capacity_provider = "FARGATE"
    }
    fargate_spot = {
      base              = 0
      weight            = 2
      capacity_provider = "FARGATE_SPOT"
    }
  }

  subnet_id              = local.private_subnets[0]
  vpc_id                 = local.vpc_id
  image_id               = data.aws_ami.amazon_ecs.image_id
  instance_type          = var.instance_type
  availability_zones     = [local.azs]
  enable_managed_scaling = var.enable_managed_scaling

  tags = merge(
    {
      Name = "${var.name}-mixed-cluster-${random_id.cluster_suffix.hex}"
    },
    var.tags
  )
}

#### Single Fargate capacity provider
module "cluster_fargate_only" {
  source = "../../"
  name   = "${var.name}-fargate-only-cluster-${random_id.cluster_suffix.hex}"

  add_capacity_providers = true
  capacity_providers     = ["FARGATE"]

  default_capacity_provider_strategy = {
    fargate_only = {
      base              = 1
      weight            = 100
      capacity_provider = "FARGATE"
    }
  }

  tags = merge(
    {
      Name = "${var.name}-fargate-only-cluster-${random_id.cluster_suffix.hex}"
    },
    var.tags
  )
}

#### Mixed Fargate + Fargate Spot strategy
module "cluster_fargate_mixed" {
  source = "../../"
  name   = "${var.name}-fargate-mixed-cluster-${random_id.cluster_suffix.hex}"

  add_capacity_providers = true
  capacity_providers     = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy = {
    fargate = {
      base              = 1
      weight            = 2
      capacity_provider = "FARGATE"
    }
    fargate_spot = {
      base              = 0
      weight            = 4
      capacity_provider = "FARGATE_SPOT"
    }
  }

  tags = merge(
    {
      Name = "${var.name}-fargate-mixed-cluster-${random_id.cluster_suffix.hex}"
    },
    var.tags
  )
}

#### Single Fargate Spot capacity provider
module "cluster_fargate_spot_only" {
  source = "../../"
  name   = "${var.name}-spot-only-cluster-${random_id.cluster_suffix.hex}"

  add_capacity_providers = true
  capacity_providers     = ["FARGATE_SPOT"]

  default_capacity_provider_strategy = {
    fargate_spot_only = {
      base              = 0
      weight            = 100
      capacity_provider = "FARGATE_SPOT"
    }
  }

  tags = merge(
    {
      Name = "${var.name}-spot-only-cluster-${random_id.cluster_suffix.hex}"
    },
    var.tags
  )
}

#### Capacity providers without default strategy
module "cluster_no_default_strategy" {
  source = "../../"
  name   = "${var.name}-no-default-strategy-${random_id.cluster_suffix.hex}"

  add_capacity_providers = true
  capacity_providers     = ["FARGATE", "FARGATE_SPOT"]
  # Intentionally no default_capacity_provider_strategy

  tags = merge(
    {
      Name = "${var.name}-no-default-strategy-${random_id.cluster_suffix.hex}"
    },
    var.tags
  )
}

#### No capacity providers (uses cluster defaults)
module "cluster_default_providers" {
  source = "../../"
  name   = "${var.name}-default-providers-${random_id.cluster_suffix.hex}"

  add_capacity_providers = false
  # Uses module default capacity_providers = ["FARGATE"]

  tags = merge(
    {
      Name = "${var.name}-default-providers-${random_id.cluster_suffix.hex}"
    },
    var.tags
  )
}
