## Security group
resource "aws_security_group" "this" {
  count       = var.create_security_group && var.create_ec2_instance ? 1 : 0
  name        = "${var.name}-security-group"
  vpc_id      = var.vpc_id
  description = "ECS cluster Security Group"
  tags        = var.tags
}

resource "aws_security_group_rule" "ingress" {
  for_each          = var.ingress_rules
  type              = "ingress"
  description       = "Allow custom inbound traffic from specific ports."
  from_port         = lookup(each.value, "from_port")
  to_port           = lookup(each.value, "to_port")
  protocol          = "-1"
  cidr_blocks       = lookup(each.value, "cidr_blocks", null)
  security_group_id = join("", aws_security_group.this.*.id)
}

resource "aws_security_group_rule" "egress" {
  for_each          = var.egress_rules
  type              = "egress"
  description       = "Allow custom egress traffic"
  from_port         = lookup(each.value, "from_port")
  to_port           = lookup(each.value, "to_port")
  protocol          = "-1"
  cidr_blocks       = lookup(each.value, "cidr_blocks", null)
  security_group_id = join("", aws_security_group.this.*.id)
}

# Iam role
resource "aws_iam_instance_profile" "this" {
  count = var.create_ec2_instance ? 1 : 0
  name  = "${var.name}-instance-profile"
  role  = aws_iam_role.cluster_instance[0].name
}

resource "aws_iam_role" "cluster_instance" {
  count              = var.create_ec2_instance ? 1 : 0
  name               = "${var.name}-cluster-instance-role"
  assume_role_policy = data.aws_iam_policy_document.container_instance.json
}

resource "aws_iam_role_policy_attachment" "ecs_cluster_ec2_role" {
  count      = var.create_ec2_instance ? 1 : 0
  role       = aws_iam_role.cluster_instance[0].id
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# Launch template
resource "aws_launch_template" "this" {
  count         = var.create_ec2_instance ? 1 : 0
  name_prefix   = "${var.name}-launch-config"
  description   = "Launch template for the ECS cluster"
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.this[0].name
  }

  user_data = var.user_data

  monitoring {
    enabled = var.monitoring_enabled
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    delete_on_termination       = var.delete_on_termination
    security_groups             = try(aws_security_group.this.*.id, "")
    subnet_id                   = var.subnet_id
  }

  block_device_mappings {
    device_name = var.device_name
    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
      encrypted   = var.encrypted
      kms_key_id  = var.ebs_kms_key_id
    }
  }

  metadata_options {
    http_endpoint               = lookup(var.metadata_options, "http_endpoint", "enabled")
    http_put_response_hop_limit = lookup(var.metadata_options, "http_put_response_hop_limit", 10)
    http_tokens                 = lookup(var.metadata_options, "http_tokens", "required")
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = var.tags
  }
}

# Auto-scaling Group
resource "aws_autoscaling_group" "container_instance" {
  count = var.create_ec2_instance ? 1 : 0
  name  = "${var.name}-asg"

  launch_template {
    id      = aws_launch_template.this[0].id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  availability_zones = var.availability_zones
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size

  lifecycle {
    create_before_destroy = true
  }
}
