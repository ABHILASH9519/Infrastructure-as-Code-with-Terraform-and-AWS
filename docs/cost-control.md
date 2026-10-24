# Cost and change controls

This repository intentionally does not run `terraform apply` in CI.

## Before planning
- Select the intended AWS CLI profile and region explicitly.
- Verify the account using `aws sts get-caller-identity`.
- Check the AWS Pricing Calculator for the resources and region you intend to use.
- Inspect the plan for VPCs, subnets, route tables, EC2, EBS and security groups.
- Keep EC2 disabled unless it is deliberately needed. Setting `enable_ec2 = true` requires a region-compatible AMI ID.
- Remember that a VPC and related network objects can still incur charges depending on the resources added later; this configuration does not add a NAT gateway by default.

## Approval gate
1. Save a plan file locally and inspect it before applying.
2. Confirm budget, tags, maintenance window and rollback/cleanup owner.
3. Apply only after a human has approved the exact plan.
4. Record the resulting resource IDs securely; never commit state or plan files.
5. For disposable experiments, destroy resources when finished and verify leftovers in the AWS console.

## State
The environment roots use local state unless a backend is configured. Do not share local state files or use concurrent applies against the same state. Before team use, configure an encrypted, versioned remote backend and state locking following your organization's standards.
