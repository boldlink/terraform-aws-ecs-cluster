# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- feat: investigate if it is possible to restrict further the permissions in `AmazonSSMManagedInstanceCore`
- feat: Add `aws_ecs_capacity_provider` resource
- feat: Add more options for launch template and autoscaling group
- feat: have the autoscaling group to be managed by AWS ECS
- feat: have both ECS Cluster and service to be created by one module
- feat: add an example that logs to s3 bucket
- feat: test container insights in complete example
- feat: option to use cmk to encrypt ec2 ebs volumes

## [2.0.1] - 2023-10-09
- fix: metadata_options block
- enabled monitoring in complete example
- disabled Instance Metadata Service Version 1

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

[Unreleased]: https://github.com/boldlink/terraform-aws-ecs-cluster/compare/2.0.1...HEAD

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
