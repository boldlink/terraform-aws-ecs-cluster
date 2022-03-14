## Description

This module Provides an ECS cluster..

Example available [here](https://github.com/boldlink/terraform-aws-ecs-cluster/tree/main/examples)
## Documentation

[AWS ecs-cluster documentation](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/clusters.html)

[Terraform provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster)
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_configuration"></a> [configuration](#input\_configuration) | (Optional) The execute command configuration for the cluster. Detailed below. | `any` | <pre>{<br>  "execute_command_configuration": {<br>    "kms_key_id": null,<br>    "log_configuration": {<br>      "cloud_watch_encryption_enabled": false,<br>      "cloud_watch_log_group_name": null,<br>      "s3_bucket_encryption_enabled": false,<br>      "s3_bucket_name": null,<br>      "s3_key_prefix": null<br>    },<br>    "logging": "NONE"<br>  }<br>}</pre> | no |
| <a name="input_container_insights"></a> [container\_insights](#input\_container\_insights) | The value to assign to the setting. Value values are enabled and disabled. | `string` | `"enabled"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment tag, e.g prod, test | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the cluster (up to 255 letters, numbers, hyphens, and underscores) | `string` | n/a | yes |
| <a name="input_other_tags"></a> [other\_tags](#input\_other\_tags) | Any additional values for tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN that identifies the cluster. |
| <a name="output_id"></a> [id](#output\_id) | ARN that identifies the cluster. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | Map of tags assigned to the resource, including those inherited from the provider default\_tags |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
