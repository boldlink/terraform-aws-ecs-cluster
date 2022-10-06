# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- feat: Add `aws_ecs_capacity_provider` resource
- feat: Add more options for launch template and autoscaling group
- feat: have the autoscaling group to be managed by AWS ECS
- feat: have both ECS Cluster and service to be created by one module
- fix: CKV_AWS_88 #EC2 instance should not have public IP
- fix: CKV_AWS_224 #Ensure Cluster logging with CMK
- feat: add an example that logs to s3 bucket
- feat: test container insights in complete example

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

[Unreleased]: https://github.com/boldlink/terraform-aws-ecs-cluster/compare/1.0.3...HEAD

[1.0.3]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/1.0.3
[1.0.2]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/1.0.2
[1.0.1]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/1.0.1
[1.0.0]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/1.0.0
