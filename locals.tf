locals {

  region     = data.aws_region.current.region
  partition  = data.aws_partition.current.partition
  account_id = data.aws_caller_identity.current.account_id
  dns_suffix = data.aws_partition.current.dns_suffix
  kms_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = var.kms_policy_iam_statement_id
          Effect = "Allow"
          Principal = {
            "AWS" = ["arn:${local.partition}:iam::${local.account_id}:root"]
          }
          Action   = ["kms:*"]
          Resource = ["*"]
        },
        {
          Sid    = var.kms_policy_cloudwatch_statement_id
          Action = var.kms_cloudwatch_actions
          Effect = "Allow"
          Principal = {
            Service = ["logs.${local.region}.${local.dns_suffix}"],
            AWS     = var.kms_policy_principal
          }
          Resource = ["*"]
          Condition = {
            ArnLike = {
              "kms:EncryptionContext:aws:logs:arn" = ["arn:${local.partition}:logs:${local.region}:${local.account_id}:log-group:/aws/ecs/${var.name}-log-group"]
            }
          }
        }
      ]
    }
  )
}
