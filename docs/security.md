# Security notes

- No AWS keys are stored in this repository.
- Keep Terraform state out of Git; it can contain sensitive values.
- Configure encrypted, versioned remote state and locking separately before team or production use.
- EC2 is opt-in, has no public IP, requires IMDSv2 and encrypts its root volume.
- Ingress is empty by default. Do not expose SSH/RDP to the public internet; prefer Systems Manager and least-privilege IAM.
- Review all Checkov findings; the CI scan is soft-fail and does not certify production readiness.
- Confirm account identity, region, plan, budget and cleanup plan before any apply.