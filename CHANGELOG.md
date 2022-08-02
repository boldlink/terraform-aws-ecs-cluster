# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- feat: Add `aws_ecs_capacity_provider` resource
- feat: Add more options for launch template and autoscaling group
- feat: have the autoscaling group to be managed by AWS ECS
- feat: have both ECS Cluster and service to be created by one module

## [1.0.2] - 2022-07-29
### Changes
- Added the `.github/workflow` folder
- Re-factored examples (`minimum` and `complete`)
- Added `CHANGELOG.md`
- Added `CODEOWNERS`
- Added `versions.tf`, which is important for pre-commit checks
- Added `Makefile` for examples automation
- Added `.gitignore` file

## [1.0.1] - 2022-04-21
### Changes
- Identifier rectification
- Added ec2 functionality

## [1.0.0] - 2022-03-11
### Changes
- Initial commit
- modified variables and introduced lookup function

[Unreleased]: https://github.com/boldlink/terraform-aws-ecs-cluster/compare/1.1.2...HEAD

[1.0.1]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/1.0.1
[1.0.0]: https://github.com/boldlink/terraform-aws-ecs-cluster/releases/tag/1.0.0
