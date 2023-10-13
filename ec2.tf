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


## Managed Policy to allow ssm agent to communicate with SSM Manager
resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.create_ec2_instance && var.install_ssm_agent ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.cluster_instance[0].id
}


# Launch template
resource "aws_launch_template" "this" {
  count         = var.create_ec2_instance ? 1 : 0
  name_prefix   = "${var.name}-launch-template"
  description   = "Launch template for ${var.name} ECS cluster"
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.this[0].name
  }

  user_data = var.install_ssm_agent ? data.template_cloudinit_config.config.rendered : var.user_data

  monitoring {
    enabled = var.monitoring_enabled
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    delete_on_termination       = var.delete_on_termination
    security_groups             = try(aws_security_group.this.*.id, "")
    subnet_id                   = var.subnet_id
  }

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name  = block_device_mappings.value.device_name
      no_device    = lookup(block_device_mappings.value, "no_device", null)
      virtual_name = lookup(block_device_mappings.value, "virtual_name", null)

      dynamic "ebs" {
        for_each = flatten([try(block_device_mappings.value.ebs, [])])
        content {
          encrypted             = try(ebs.value.encrypted, null)
          kms_key_id            = try(ebs.value.kms_key_id, null)
          delete_on_termination = try(ebs.value.delete_on_termination, null)
          iops                  = try(ebs.value.iops, null)
          throughput            = try(ebs.value.throughput, null)
          snapshot_id           = try(ebs.value.snapshot_id, null)
          volume_size           = try(ebs.value.volume_size, null)
          volume_type           = try(ebs.value.volume_type, null)
        }
      }
    }
  }

  metadata_options {
    http_endpoint               = lookup(var.metadata_options, "http_endpoint", "enabled")
    http_put_response_hop_limit = lookup(var.metadata_options, "http_put_response_hop_limit", null)
    http_tokens                 = lookup(var.metadata_options, "http_tokens", "optional")
    http_protocol_ipv6          = lookup(var.metadata_options, "value.http_protocol_ipv6", null)
    instance_metadata_tags      = lookup(var.metadata_options, "value.instance_metadata_tags", null)
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
    version = var.launch_template_version
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
