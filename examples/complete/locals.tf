locals {
  subnet_az = [
    for az in data.aws_subnet.private : az.availability_zone
  ]
  private_subnet_id = [
    for i in data.aws_subnet.private : i.id
  ]
  region = data.aws_region.current.name
  azs    = local.subnet_az[0]
  vpc_id = data.aws_vpc.supporting.id

  ecs_instance_userdata = <<USERDATA
  #!/bin/bash -x
  cat <<'EOF' >> /etc/ecs/ecs.config
  ECS_CLUSTER=${var.name}
  EOF
  USERDATA

  private_subnets = local.private_subnet_id
  partition       = data.aws_partition.current.partition
  tags            = merge({ "Name" = var.name }, var.tags)

  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      ebs = {
        delete_on_termination = true
        volume_size           = 20
        volume_type           = "gp2"
        encrypted             = true
        kms_key_id            = data.aws_kms_alias.ebs.target_key_arn
      }
    },
    {
      device_name = "/dev/xvdcz"
      ebs = {
        delete_on_termination = true
        volume_size           = 22
        volume_type           = "gp2"
        encrypted             = true
        kms_key_id            = data.aws_kms_alias.ebs.target_key_arn
      }
    },
    {
      device_name = "/dev/sdf"
      no_device   = true
    },
    {
      device_name  = "/dev/sdb"
      virtual_name = "ephemeral0"
    }
  ]

  default_container_definitions = jsonencode(
    [
      {
        name      = var.name
        image     = var.image
        cpu       = var.cpu
        memory    = var.memory
        essential = var.essential
        portMappings = [
          {
            containerPort = var.containerport
            hostPort      = var.hostport
          }
        ]
        logConfiguration = {
          logDriver = "awslogs",
          options = {
            awslogs-group         = "/aws/ecs-service/${var.name}-service",
            awslogs-region        = local.region,
            awslogs-stream-prefix = "task"
          }
        }
      }
    ]
  )

  task_execution_role_policy_doc = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [{
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = ["arn:${local.partition}:logs:::log-group:${var.name}"]
        },
        {
          Effect = "Allow"
          Action = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]

          Resource = ["*"]
        }
    ] }
  )
}
