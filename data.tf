data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "container_instance" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  # Cloud-config configuration for installing ssm agent.
  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/scripts/userdata.sh", {})
  }

  # Additional script
  part {
    content_type = "text/x-shellscript"
    content      = var.extra_script
  }
}
