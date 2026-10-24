# Operations checklist

1. Confirm the intended AWS account with `aws sts get-caller-identity`.
2. Confirm region, availability zones and CIDR non-overlap.
3. Run `terraform fmt -check -recursive`, `init`, and `validate`.
4. Create and review a saved plan; inspect every proposed resource.
5. Estimate cost. NAT gateways, EC2, EBS, data transfer and logging may incur charges.
6. Apply only after explicit approval.
7. Record outputs without committing state files.
8. Destroy disposable resources and verify the account for leftovers.