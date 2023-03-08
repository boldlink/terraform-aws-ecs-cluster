locals {

  region     = data.aws_region.current.name
  partition  = data.aws_partition.current.partition
  account_id = data.aws_caller_identity.current.account_id
  dns_suffix = data.aws_partition.current.dns_suffix
  kms_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "Enable IAM User Permissions"
          Effect = "Allow"
          Principal = {
            "AWS" = ["arn:${local.partition}:iam::${local.account_id}:root"]
          }
          Action   = ["kms:*"]
          Resource = ["*"]
        },
        {
          Sid = "AllowCloudWatchLogs"
          Action = [
            "kms:Encrypt*",
            "kms:Decrypt*",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Describe*"
          ]
          Effect = "Allow"
          Principal = {
            Service = ["logs.${local.region}.${local.dns_suffix}"],
            AWS     = "*"
          }
          Resource = ["*"]
          Condition = {
            ArnLike = {
              "kms:EncryptionContext:aws:logs:arn" = ["arn:${local.partition}:logs:${local.region}:${local.account_id}:log-group:${var.name}-log-group"]
            }
          }
        }
      ]
    }
  )
}
