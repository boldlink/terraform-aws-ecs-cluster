[![License](https://img.shields.io/badge/License-Apache-blue.svg)](https://github.com/boldlink/terraform-aws-ecs-cluster/blob/main/LICENSE)
[![Latest Release](https://img.shields.io/github/release/boldlink/terraform-aws-ecs-cluster.svg)](https://github.com/boldlink/terraform-aws-ecs-cluster/releases/latest)
[![Build Status](https://github.com/boldlink/terraform-aws-ecs-cluster/actions/workflows/update.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ecs-cluster/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ecs-cluster/actions/workflows/release.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ecs-cluster/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ecs-cluster/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ecs-cluster/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ecs-cluster/actions/workflows/pr-labeler.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ecs-cluster/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ecs-cluster/actions/workflows/module-examples-tests.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ecs-cluster/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ecs-cluster/actions/workflows/checkov.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ecs-cluster/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ecs-cluster/actions/workflows/auto-merge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ecs-cluster/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-ecs-cluster/actions/workflows/auto-badge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-ecs-cluster/actions)

[<img src="https://avatars.githubusercontent.com/u/25388280?s=200&v=4" width="96"/>](https://boldlink.io)

# Terraform module example of complete and most common configuration

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.21.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster"></a> [cluster](#module\_cluster) | ../../ | n/a |
| <a name="module_cluster_bucket"></a> [cluster\_bucket](#module\_cluster\_bucket) | boldlink/s3/aws | 2.3.1 |
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | boldlink/ecs-service/aws | 1.5.3 |
| <a name="module_log_to_s3"></a> [log\_to\_s3](#module\_log\_to\_s3) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role_policy.task_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_ami.amazon_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.ecs_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_alias.ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.supporting](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Associate a public ip address with the network interface. Boolean value. | `bool` | `false` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | The number of cpu units to allocate | `number` | `10` | no |
| <a name="input_create_ec2_instance"></a> [create\_ec2\_instance](#input\_create\_ec2\_instance) | Whether or not to create a cluster ec2 instance(s) | `bool` | `true` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Whether or not to create a kms key with this module | `bool` | `true` | no |
| <a name="input_essential"></a> [essential](#input\_essential) | Whether this container is essential | `bool` | `true` | no |
| <a name="input_image"></a> [image](#input\_image) | Name of image to pull from dockerhub | `string` | `"nginx"` | no |
| <a name="input_install_ssm_agent"></a> [install\_ssm\_agent](#input\_install\_ssm\_agent) | Whether to install ssm agent | `bool` | `true` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of the instance. | `string` | `"t3.medium"` | no |
| <a name="input_key_description"></a> [key\_description](#input\_key\_description) | The description of the key as viewed in AWS console. | `string` | `"KMS key to encrypt the data between the local client and the container and cloudwatch logs."` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | Launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL. Defaults to EC2. | `string` | `"EC2"` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | The log setting to use for redirecting logs for your execute command results. Valid values are NONE, DEFAULT, and OVERRIDE. | `string` | `"OVERRIDE"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | (Required) The maximum size of the Auto Scaling Group | `number` | `2` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | The size of memory to allocate in MiBs | `number` | `512` | no |
| <a name="input_monitoring_enabled"></a> [monitoring\_enabled](#input\_monitoring\_enabled) | The monitoring option for the instance. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the cluster (up to 255 letters, numbers, hyphens, and underscores) | `string` | `"complete-ecs-cluster-example"` | no |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | Docker networking mode to use for the containers in the task. Valid values are none, bridge, awsvpc, and host. | `string` | `"bridge"` | no |
| <a name="input_requires_compatibilities"></a> [requires\_compatibilities](#input\_requires\_compatibilities) | Set of launch types required by the task. The valid values are EC2 and FARGATE. | `list(string)` | `[]` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `7` | no |
| <a name="input_service_ingress_rules"></a> [service\_ingress\_rules](#input\_service\_ingress\_rules) | Ingress rules to add to the service security group. | `list(any)` | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow traffic on port 5000. The app is configured to use this port",<br>    "from_port": 5000,<br>    "protocol": "tcp",<br>    "to_port": 5000<br>  }<br>]</pre> | no |
| <a name="input_supporting_resources_name"></a> [supporting\_resources\_name](#input\_supporting\_resources\_name) | Name of the supporting resources name tag | `string` | `"terraform-aws-ecs-cluster"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the object. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | <pre>{<br>  "Department": "DevOps",<br>  "Environment": "example",<br>  "InstanceScheduler": true,<br>  "LayerId": "Example",<br>  "LayerName": "Example",<br>  "Owner": "Boldlink",<br>  "Project": "Examples",<br>  "user::CostCenter": "terraform-registry"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Third party software
This repository uses third party software:
* [pre-commit](https://pre-commit.com/) - Used to help ensure code and documentation consistency
  * Install with `brew install pre-commit`
  * Manually use with `pre-commit run`
* [terraform 0.14.11](https://releases.hashicorp.com/terraform/0.14.11/) For backwards compatibility we are using version 0.14.11 for testing making this the min version tested and without issues with terraform-docs.
* [terraform-docs](https://github.com/segmentio/terraform-docs) - Used to generate the [Inputs](#Inputs) and [Outputs](#Outputs) sections
  * Install with `brew install terraform-docs`
  * Manually use via pre-commit
* [tflint](https://github.com/terraform-linters/tflint) - Used to lint the Terraform code
  * Install with `brew install tflint`
  * Manually use via pre-commit

#### BOLDLink-SIG 2023
