data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_kms_alias" "ebs" {
  name = "alias/aws/ebs"
}

data "aws_ami" "amazon_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["${var.supporting_resources_name}*.pri.*"]
  }
}

data "aws_vpc" "supporting" {
  filter {
    name   = "tag:Name"
    values = [var.supporting_resources_name]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_policy" {
  #checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
  #checkov:skip=CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
  statement {
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
      "kms:Decrypt",
      "logs:DescribeLogGroups",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}
