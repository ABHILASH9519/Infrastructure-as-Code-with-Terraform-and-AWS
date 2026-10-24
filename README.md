# Terraform AWS Infrastructure

Reusable, environment-aware AWS infrastructure using Terraform. No resources are created until you explicitly run an approved apply.

## Features
- Reusable VPC module: public/private subnets, route tables, internet gateway
- Optional EC2 module with IMDSv2 required and encrypted root EBS
- Separate dev and prod roots
- CI formatting, validation and Checkov security scan
- No committed credentials or state files

## Quick start
Prerequisites: Terraform >= 1.6, AWS CLI v2, and an explicitly selected AWS account/profile.

```bash
terraform -chdir=environments/dev init
terraform -chdir=environments/dev fmt -check -recursive
terraform -chdir=environments/dev validate
terraform -chdir=environments/dev plan
```

EC2 is disabled by default. The network plan still proposes billable/account resources if applied; review the plan and AWS costs before applying. CI never applies infrastructure.

## Credentials
Use AWS CLI profiles or short-lived federation; never commit access keys, state, or secret tfvars. Confirm the target with `aws sts get-caller-identity`. Configure an encrypted, versioned remote backend and locking strategy separately before team/production use.

## Modules
- `modules/network`: VPC, public/private subnets and route tables. No NAT gateway by default.
- `modules/compute`: opt-in EC2 instance, no public IP, IMDSv2 required, encrypted root volume, no ingress unless configured.

## Environments
- `environments/dev`
- `environments/prod`

Availability zones must exist in the selected region and CIDRs must not overlap existing networks. The production root is a starting point, not a production certification.

## Cleanup
For resources you intentionally applied, inspect and run `terraform -chdir=environments/dev destroy`. Verify the account afterwards for any resources not tracked by this state.

No AWS deployment is claimed by this repository.