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

## Description

An ECS Terraform module helps automate the provisioning and management of Amazon Elastic Container Service (ECS) resources within an AWS infrastructure. It is also compatible with other Terraform modules and AWS services.

### Why choose this module
- Improved security: The module can be used to manage and enforce security best practices for ECS resources, such as creating and managing security groups and role-based access controls.
- Easy to set up and use, with clear instructions and examples available.
- Allow you to configure encryption for containers execute command. NOTE: this configurations are only available through the API not the web console.
- ensures EBS volumes created for EC2 instances are encrypted by default.

## Connecting to Instances
- Use SSM Manager CLI to connect to instance Linux and Windows ec2 instances.
- **NOTE:** It's crucial to configure the security group outbound rules to allow all traffic to any destination (`0.0.0.0/0`). This is necessary because the instance requires the capability to send requests for downloading packages.

### Using AWS CLI to start Systems Manager Session
- Make sure you have the Session Manager plugin installed on your system. For installation instructions, refer to the guide [here](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)
- Run the following command to start session from your terminal
```console
aws ssm start-session \
    --target "<instance_id>"
```
Replace `<instance_id>` with the ID of the instance you want to connect to

## Launching in Private Subnets without NAT Gateways or internet connection
To manage instances in isolated subnets without internet connectivity, it is necessary to enable VPC endpoints for specific services, including:
- `com.amazonaws.[region].ssm`
- `com.amazonaws.[region].ec2messages`
- `com.amazonaws.[region].ssmmessages`
- `(optional) com.amazonaws.[region].kms for KMS encryption in Session Manager`

You can use Boldlink VPC Endpoints Terraform module [here](https://github.com/boldlink/terraform-aws-vpc-endpoints/tree/main/examples)

## Running commands in ecs containers using ECS Exec
With Amazon ECS Exec, you can directly interact with containers without needing to first interact with the host container operating system, open inbound ports, or manage SSH keys. You can use ECS Exec to run commands in or get a shell to a container running on an Amazon EC2 instance or on AWS Fargate. This makes it easier to collect diagnostic information and quickly troubleshoot errors. For example, in a development context, you can use ECS Exec to easily interact with various process in your containers and troubleshoot your applications. And, in production scenarios, you can use it to gain break-glass access to your containers to debug issues.

You can also use ECS Exec to maintain stricter access control policies and audit container access. By selectively turning on this feature, you can control who can run commands and on which tasks they can run those commands. With a log of each command and their output, you can use ECS Exec to audit which tasks were run and you can use CloudTrail to audit who accessed a container.

You can open an interactive shell on your container using the following command.

```
aws ecs execute-command --cluster <cluster_name> \
    --task <task_id> \
    --container <container_name> \
    --interactive \
    --command "<command_to_execute> " # e.g /bin/sh
```
If your task contains multiple containers, you must specify the container name using the --container flag. Amazon ECS only supports initiating interactive sessions, so you must use the --interactive flag.

### Logging and Auditing using ECS Exec
Amazon ECS provides a default configuration for logging commands run using ECS Exec by sending logs to CloudWatch Logs using the `awslogs` log driver that's configured in your task definition. If you want to provide a custom configuration, use the module's configuration block.

The logging variable determines the behavior of the logging capability of ECS Exec:

- NONE: logging is turned off

- DEFAULT: logs are sent to the configured `awslogs` driver (If the driver isn't configured, then no log is saved.)

- OVERRIDE: logs are sent to the provided Amazon CloudWatch Logs LogGroup, Amazon S3 bucket, or both

To enable logging, the Amazon ECS task role that's referenced in your task definition needs to have additional permissions. These additional permissions can be added as a policy to the task role. They are different depending on if you direct your logs to Amazon CloudWatch Logs or Amazon S3. For more information, refer [here](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html)

### Verify using the Amazon ECS Exec Checker
The Amazon ECS Exec Checker script provides a way to verify and validate that your Amazon ECS cluster and task have met the prerequisites for using the ECS Exec feature. The Exec Checker script verifies both your AWS CLI environment and cluster and tasks are ready for ECS Exec, by calling various APIs on your behalf. The tool requires the latest version of the AWS CLI and that the jq is available. For more information, see [Amazon ECS Exec Checker on GitHub](https://github.com/aws-containers/amazon-ecs-exec-checker).

Examples available [here](./examples)

## Usage
**NOTE**: These examples utilize the most recent version of this module. To do so, specify the source without including a version number, as demonstrated below.

```hcl
#### Minimum example
locals {
  name = "minimum-ecs-cluster-example"
  tags = {
    Environment        = "examples"
    Name               = local.name
    "user::CostCenter" = "terraform-registry"
  }
}

module "minimum_cluster" {
  source  = "boldlink/ecs-cluster/aws"
  version = "<add_latest_version_here>"
  name    = local.name
  tags    = local.tags
}
```

## Documentation

[AWS ecs-cluster documentation](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/clusters.html)

[Terraform provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.21.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.container_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.cluster_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_cluster_ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.container_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [template_cloudinit_config.config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_capacity_providers"></a> [add\_capacity\_providers](#input\_add\_capacity\_providers) | Whether or not to deploy aws\_cluster\_capacity\_providers resource | `bool` | `false` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Associate a public ip address with the network interface. Boolean value. | `bool` | `true` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | (Optional) A list of one or more availability zones for the group. Used for EC2-Classic, attaching a network interface via id from a launch template | `list(string)` | `[]` | no |
| <a name="input_block_device_mappings"></a> [block\_device\_mappings](#input\_block\_device\_mappings) | (Optional) Specify volumes to attach to the instance besides the volumes specified by the AMI. | `any` | `[]` | no |
| <a name="input_capacity_providers"></a> [capacity\_providers](#input\_capacity\_providers) | (Optional) Set of names of one or more capacity providers to associate with the cluster. Valid values also include FARGATE and FARGATE\_SPOT. | `list(string)` | <pre>[<br>  "FARGATE"<br>]</pre> | no |
| <a name="input_configuration"></a> [configuration](#input\_configuration) | (Optional) The execute command configuration for the cluster. Detailed below. | `any` | `{}` | no |
| <a name="input_container_insights"></a> [container\_insights](#input\_container\_insights) | The value to assign to the setting. Value values are enabled and disabled. | `string` | `"enabled"` | no |
| <a name="input_create_ec2_instance"></a> [create\_ec2\_instance](#input\_create\_ec2\_instance) | Whether or not to create a cluster ec2 instance(s) | `bool` | `false` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Whether or not to create a kms key with this module | `bool` | `false` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Whether to create a Security Group for ECS cluster. | `bool` | `true` | no |
| <a name="input_default_capacity_provider_strategy"></a> [default\_capacity\_provider\_strategy](#input\_default\_capacity\_provider\_strategy) | (Optional) Set of capacity provider strategies to use by default for the cluster. | `map(any)` | `{}` | no |
| <a name="input_delete_on_termination"></a> [delete\_on\_termination](#input\_delete\_on\_termination) | Whether the network interface should be destroyed on instance termination. Defaults to false if not set. | `bool` | `true` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | (Optional) The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30. | `number` | `30` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | (Optional) The number of Amazon EC2 instances that should be running in the group. | `number` | `1` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | (Optional) Egress rules to add to the security group | `any` | `{}` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | (Optional) Specifies whether key rotation is enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_extra_script"></a> [extra\_script](#input\_extra\_script) | The name of the extra script | `string` | `""` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | (Optional) The AMI from which to launch the instance. | `string` | `null` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | (Optional) Ingress rules to add to the security group | `any` | `{}` | no |
| <a name="input_install_ssm_agent"></a> [install\_ssm\_agent](#input\_install\_ssm\_agent) | Whether to install ssm agent | `bool` | `false` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | (Optional) The type of the instance. | `string` | `null` | no |
| <a name="input_key_description"></a> [key\_description](#input\_key\_description) | The description of the key as viewed in AWS console. | `string` | `null` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | (Optional) The key name to use for the instance. | `string` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | (Optional) The AWS Key Management Service key ID to encrypt the data between the local client and the container. | `string` | `null` | no |
| <a name="input_launch_template_version"></a> [launch\_template\_version](#input\_launch\_template\_version) | The version of the launch template | `string` | `"$Latest"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | (Required) The maximum size of the Auto Scaling Group | `number` | `10` | no |
| <a name="input_metadata_options"></a> [metadata\_options](#input\_metadata\_options) | Customize the metadata options of the instance | `map(string)` | `{}` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | (Required) The minimum size of the Auto Scaling Group. | `number` | `1` | no |
| <a name="input_monitoring_enabled"></a> [monitoring\_enabled](#input\_monitoring\_enabled) | (Optional) The monitoring option for the instance. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the cluster (up to 255 letters, numbers, hyphens, and underscores) | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The subnet ID to launch the instances in | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value map of resource tags. | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | (Optional) The base64-encoded user data to provide when launching the instance. | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Optional, Forces new resource) VPC ID | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN that identifies the cluster. |
| <a name="output_id"></a> [id](#output\_id) | ARN that identifies the cluster. |
| <a name="output_key_arn"></a> [key\_arn](#output\_key\_arn) | The Amazon Resource Name (ARN) of the key. |
| <a name="output_key_id"></a> [key\_id](#output\_key\_id) | The globally unique identifier for the key. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | Map of tags assigned to the resource, including those inherited from the provider default\_tags |
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

### Supporting resources:

The example stacks are used by BOLDLink developers to validate the modules by building an actual stack on AWS.

Some of the modules have dependencies on other modules (ex. Ec2 instance depends on the VPC module) so we create them
first and use data sources on the examples to use the stacks.

Any supporting resources will be available on the `tests/supportingResources` and the lifecycle is managed by the `Makefile` targets.

Resources on the `tests/supportingResources` folder are not intended for demo or actual implementation purposes, and can be used for reference.

### Makefile
The makefile contained in this repo is optimized for linux paths and the main purpose is to execute testing for now.
* Create all tests stacks including any supporting resources:
```console
make tests
```
* Clean all tests *except* existing supporting resources:
```console
make clean
```
* Clean supporting resources - this is done separately so you can test your module build/modify/destroy independently.
```console
make cleansupporting
```
* !!!DANGER!!! Clean the state files from examples and test/supportingResources - use with CAUTION!!!
```console
make cleanstatefiles
```


#### BOLDLink-SIG 2023
