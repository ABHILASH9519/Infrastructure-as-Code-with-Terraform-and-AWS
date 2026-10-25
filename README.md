<div align="center">

# ☁️ Terraform AWS Infrastructure

**Reusable, environment-aware Infrastructure as Code with security-conscious defaults**

[![Terraform Checks](https://github.com/ABHILASH9519/Infrastructure-as-Code-with-Terraform-and-AWS/actions/workflows/terraform-checks.yml/badge.svg)](https://github.com/ABHILASH9519/Infrastructure-as-Code-with-Terraform-and-AWS/actions/workflows/terraform-checks.yml)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud%20Infrastructure-FF9900?logo=amazonaws&logoColor=white)
![Security](https://img.shields.io/badge/Security-IMDSv2%20%2B%20Encrypted%20EBS-2E8B57)

[Architecture](#-architecture) · [Provisioning flow](#-provisioning-flow) · [Quick start](#-quick-start) · [Security](#-safety-defaults)

</div>

---

Reusable, environment-aware AWS infrastructure using Terraform. This repository is designed to be reviewed and validated before any human-approved deployment.

## ✨ Capabilities

- Reusable VPC module with public/private subnets, route tables and internet gateway
- Optional EC2 module with no public IP, required IMDSv2 and encrypted root EBS
- Separate development and production root modules
- Input validation for CIDR syntax, subnet/AZ list lengths and optional EC2 AMI
- GitHub Actions formatting and validation for both environments
- Checkov security scan (currently advisory/soft-fail)

## 🧭 Architecture

```mermaid
flowchart TB
    Dev[environments/dev] --> Net[Reusable network module]
    Prod[environments/prod] --> Net
    Dev --> Compute[Optional compute module]
    Prod --> Compute
    Net --> VPC[VPC]
    VPC --> IGW[Internet Gateway]
    VPC --> Pub[Public subnets + route table]
    VPC --> Priv[Private subnets + route table]
    Compute --> EC2[Optional EC2 instance]
    EC2 --> SG[Security Group: no inbound by default]
    EC2 --> EBS[Encrypted root EBS + IMDSv2]
    CI[GitHub Actions] --> Fmt[Terraform format + validate]
    CI --> Scan[Checkov security scan]
    style Net fill:#EDE9FE,stroke:#7C3AED,color:#4C1D95
    style VPC fill:#DBEAFE,stroke:#2563EB,color:#1E3A8A
    style EC2 fill:#DCFCE7,stroke:#16A34A,color:#14532D
    style CI fill:#FEF3C7,stroke:#D97706,color:#78350F
```

## 🔄 Provisioning flow

```mermaid
flowchart TD
    A[Review environment variables] --> B[terraform fmt]
    B --> C[terraform init -backend=false]
    C --> D[terraform validate]
    D --> E[Checkov scan]
    E --> F[Review terraform plan and cost]
    F --> G{Human approval?}
    G -- No --> H[Revise configuration]
    H --> A
    G -- Yes --> I[Operator applies manually]
    style G fill:#FEF3C7,stroke:#D97706,color:#78350F
    style I fill:#DCFCE7,stroke:#16A34A,color:#14532D
```

## ⚡ Quick start

Prerequisites: Terraform >= 1.6, AWS CLI v2 and a deliberately selected AWS account/profile.

```bash
terraform -chdir=environments/dev init
terraform -chdir=environments/dev fmt -check -recursive
terraform -chdir=environments/dev validate
terraform -chdir=environments/dev plan
```

Review the plan and estimated costs. Do not apply without approval. CI never runs `terraform apply` and does not deploy resources.

## 🛡️ Safety defaults

- EC2 is disabled by default.
- No public IP is assigned to the optional instance.
- IMDSv2 is required and the root volume is encrypted.
- Inbound security-group rules are empty unless HTTPS CIDRs are explicitly configured.
- No NAT gateway is provisioned by default.
- Credentials, state and plan files must stay out of Git.

## 📚 Documentation

- [Architecture and module contracts](docs/architecture.md)
- [Operations checklist](docs/operations.md)
- [Cost and change controls](docs/cost-control.md)
- [Security notes](docs/security.md)

The production root is an educational starting point, not a production certification. Account-specific deployment, costs, IAM, remote state, monitoring, backup and disaster recovery still require deliberate configuration and review.
