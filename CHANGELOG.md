# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- feat: investigate if it is possible to restrict further the permissions in `AmazonSSMManagedInstanceCore`
- fix: ecs-service version used in complete example: The current version requires task role permissions modification outside the module using a resource.

## [3.0.0] - 2025-06-30
- feat: Add `aws_ecs_capacity_provider` resource support with managed scaling
- feat: Add `enable_managed_scaling` variable for ECS-managed Auto Scaling Groups
- feat: Add `autoscaling_group_arn` and `autoscaling_group_name` outputs
- feat: Add `AmazonECSManaged` tag support for capacity provider integration
- feat: Add `protect_from_scale_in` support for Auto Scaling Groups
- feat: Add comprehensive capacity provider testing (12 scenarios)
- feat: Add complete metadata options configuration support
- feat: Add all ECS Exec logging modes (OVERRIDE, DEFAULT, NONE)
- feat: Add S3 logging with encryption support
- feat: Add custom user_data testing alongside extra_script
- feat: Add existing KMS key usage examples
- feat: Add mixed Fargate + Fargate Spot capacity strategies
- feat: Add single capacity provider configurations
- feat: Add ARM64/Apple Silicon Mac compatibility
- update: ECS service module version from 1.5.3 to 1.12.2
- update: Module argument names for ECS service compatibility
- update: Complete example variable coverage from ~60% to 100%
- update: Shortened module names to fix IAM role 64-character limits
- update: Enhanced VPC detection with fallback to default VPC
- update: Improved error messages with actionable solutions
- fix: Deprecated `data.aws_region.current.name` to `data.aws_region.current.region`
- fix: Removed deprecated `hashicorp/template` provider dependency
- fix: Replaced `template_cloudinit_config` with built-in Terraform functions
- fix: Added missing tags to KMS key, IAM instance profile, and IAM role
- fix: ECS capacity provider managed termination protection requirements
- fix: Mixed capacity provider strategy AWS API validation errors
- fix: Empty collection errors in locals with safe subnet handling
- fix: Duplicate `enable_managed_scaling` attribute declaration
- fix: Resource reference conflicts in VPC creation logic
- fix: IAM role name length exceeding AWS limits
- remove: Template provider dependency and references
- remove: VPC creation resources causing reference conflicts
- remove: Deprecated AWS provider attribute usage
- feat: Add configurable ECS execute command logging mode variable
- feat: Add configurable KMS policy statement IDs and permissions
- feat: Add configurable security group descriptions and protocols
- feat: Add configurable ASG tag propagation settings
- feat: Add configurable SSM agent installation URLs and versions
- feat: Add configurable SSM agent temporary directory path
- fix: AmazonECSManaged tag propagation setting for ECS managed scaling
- fix: Module hardcoded values moved to configurable variables with defaults
- feat: Add configurable ECS managed tag key, value, and propagation settings
- feat: Add default EBS volume type (gp3) and encryption configuration
- feat: Add configurable EBS KMS key support (aws/ebs or custom CMK)
- feat: Add ec2_volume_sizes variable for standardized volume sizing
- feat: Add automatic default root volume creation with secure defaults
- feat: Add configurable resource naming suffixes for all AWS resources
- feat: Add configurable EC2 metadata options defaults
- feat: Add independent scale-in protection control
- feat: option to use cmk to encrypt ec2 ebs volumes

## [2.0.2] - 2023-10-17
- fix: ecs task role permissions in complete example
- ecs cluster example that logs exec commands to s3
- ecs cluster example that has capacity provider configuration

## [2.0.1] - 2023-10-09
- fix: metadata_options block
- enabled monitoring in complete example
- disabled Instance Metadata Service Version 1
- added an ecs service example that runs on ecs-ec2 cluster
- added no_device, virtual device and encrypted ebs volumes in complete example

## [2.0.0] - 2023-09-05
- feat: Added ssm support for launched instances
- feat: removed key pair creation feature which brings breaking changes. This means that ssh by using key pair is no longer supported

## [1.1.1] - 2023-06-01
- fix: kms key outputs

## [1.1.0] - 2023-03-08
- feat: option to create one kms key for encryption inside the module
- feat: dynamic ebs volume option in launch template
- fix: some volumes were not encrypted upon creation

## [1.0.7] - 2023-02-01
- fix: CKV_AWS_158 "Ensure that CloudWatch Log Group is encrypted by KMS"

## [1.0.6] - 2023-01-25
- fix: CKV_AWS_66 "Ensure that CloudWatch Log Group specifies retention days"

## [1.0.5] - 2023-01-13
- fix: CKV_AWS_224 Ensure Cluster logging with CMK
- feat: Added new automation workflows

## [1.0.4] - 2022-11-04
### Changes
- fix: CKV_AWS_88 #EC2 instance should not have public IP

## [1.0.3] - 2022-09-27
### Changes
- fix: CKV_AWS_79 #Ensure Instance Metadata Service Version 1 is not enabled
- fix: CKV_AWS_153 #Autoscaling groups should supply tags to launch configurations

## [1.0.2] - 2022-08-02
### Changes
- Added the `.github/workflow` folder
- Re-factored examples (`minimum` and `complete`)
- Added `CHANGELOG.md`
- Added `CODEOWNERS`
- Added `versions.tf`, which is important for pre-commit checks
- Added `Makefile` for examples automation
- Added `.gitignore` file
- fix: (urgent) terraform crashing when deploying minimum and complete examples
- fix: restructure terraform block causing crash
- feat: added supporting resources

## [1.0.1] - 2022-04-21
### Changes
- Identifier rectification
- Added ec2 functionality

## [1.0.0] - 2022-03-11
### Changes
- Initial commit
- modified variables and introduced lookup function

[Unreleased]: https://github.com/boldlink/terraform-aws-ecs-cluster/compare/3.0.0...HEAD

[3.0.0]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/3.0.0
[2.0.2]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/2.0.2
[2.0.1]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/2.0.1
[2.0.0]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/2.0.0
[1.1.0]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/1.1.0
[1.0.7]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/1.0.7
[1.0.6]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/1.0.6
[1.0.5]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/1.0.5
[1.0.4]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/1.0.4
[1.0.3]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/1.0.3
[1.0.2]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/1.0.2
[1.0.1]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/1.0.1
[1.0.0]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/1.0.0
