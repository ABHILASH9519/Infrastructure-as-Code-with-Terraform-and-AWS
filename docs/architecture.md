# Architecture and module contracts

## Environment roots

`environments/dev` and `environments/prod` are separate Terraform root modules. Each selects the AWS provider region, supplies environment-specific CIDR ranges and tags, and composes reusable modules.

## Network module

- Creates a VPC, public and private subnets, an internet gateway, route tables and associations.
- Requires equal, non-zero counts of availability zones, public subnets and private subnets.
- Validates CIDR input syntax before AWS API calls.
- Does not create a NAT gateway; private subnets therefore do not automatically have outbound internet access.

## Compute module

- Is opt-in through the environment variable `enable_ec2` (false by default).
- Places the instance in the selected subnet without a public IP.
- Requires IMDSv2, encrypts the root EBS volume and uses a security group with no inbound rules unless explicit HTTPS CIDRs are configured.
- The supplied subnet ID must exist in the selected AWS account and region. The AMI must be valid for that region.

## Architecture diagram

```mermaid
flowchart TB
    subgraph Roots["Environment root modules"]
      Dev[dev root]
      Prod[prod root]
    end
    Dev --> Network[Reusable network module]
    Prod --> Network
    Dev --> Compute[Optional compute module]
    Prod --> Compute
    Network --> VPC[VPC]
    VPC --> IGW[Internet Gateway]
    VPC --> Public[Public subnets + route table]
    VPC --> Private[Private subnets + route table]
    Compute --> EC2[EC2 instance: opt-in]
    EC2 --> SG[Security group: inbound empty by default]
    EC2 --> EBS[Encrypted EBS + IMDSv2]
    CI[GitHub Actions] --> Validation[fmt + init backend-free + validate]
    CI --> Checkov[Checkov scan: advisory / soft-fail]
    style Network fill:#EDE9FE,stroke:#7C3AED,color:#4C1D95
    style VPC fill:#DBEAFE,stroke:#2563EB,color:#1E3A8A
    style EC2 fill:#DCFCE7,stroke:#16A34A,color:#14532D
```

## Provisioning and review workflow

```mermaid
flowchart LR
    Edit[Edit environment inputs] --> Format[terraform fmt]
    Format --> Init[terraform init -backend=false]
    Init --> Validate[terraform validate]
    Validate --> Scan[Checkov scan]
    Scan --> Plan[Review plan and cost]
    Plan --> Approval{Human approval}
    Approval -- No --> Edit
    Approval -- Yes --> Apply[Operator-run apply]
    style Approval fill:#FEF3C7,stroke:#D97706,color:#78350F
    style Apply fill:#DCFCE7,stroke:#16A34A,color:#14532D
```

## Trust boundaries and limitations

CI runs formatting, backend-free initialization, validation and a soft-fail Checkov scan. It does not authenticate to AWS, create a plan against a live account, apply infrastructure or prove that an account-specific deployment will succeed. The prod root is a starting point and is not a production certification.
