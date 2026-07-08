# infra-db

Terraform infrastructure for provisioning isolated PostgreSQL RDS databases for the FIAP-X video processing platform.

## Architecture

Each microservice gets its own dedicated RDS instance, ensuring **complete database isolation** — no service can access another service's database directly.

| Service              | Database Name       | RDS Identifier            |
|----------------------|---------------------|---------------------------|
| auth-service         | fiapx_auth          | fiapx-auth-db             |
| upload-service       | fiapx_upload        | fiapx-upload-db           |
| video-processor      | fiapx_processor     | fiapx-processor-db        |
| status-service       | fiapx_status        | fiapx-status-db           |
| notification-service | fiapx_notification  | fiapx-notification-db     |

## Infrastructure Details

- **Engine**: PostgreSQL 16.3
- **Instance Class**: db.t3.micro
- **Storage**: 20 GB (allocated)
- **Accessibility**: Private subnets only (not publicly accessible)
- **Security Group**: Allows port 5432 from within the VPC CIDR only
- **Subnet Group**: Uses two private subnets in different AZs (from infra-k8s)
- **Deletion Protection**: Disabled (for development/academic use)

## Dependencies

This module depends on **[infra-k8s](https://github.com/Sala-16-Hackathon-FIAP/infra-k8s)** being applied first. It reads VPC and subnet IDs via Terraform remote state:

```
S3 Bucket: fiapx-terraform-state
State Key:  k8s/terraform.tfstate
```

### Deploy Order

```
1. infra-k8s   (VPC, EKS, S3, RabbitMQ)
2. infra-db    (RDS instances) <-- this repo
3. Microservices (deployed to EKS via CI/CD)
```

## Terraform State

State is stored remotely in S3:

```
Bucket: fiapx-terraform-state
Key:    rds/terraform.tfstate
Region: us-east-1
```

## Outputs

| Output                      | Description                              |
|-----------------------------|------------------------------------------|
| `auth_db_endpoint`          | auth-service PostgreSQL endpoint         |
| `upload_db_endpoint`        | upload-service PostgreSQL endpoint       |
| `processor_db_endpoint`     | video-processor-service PostgreSQL endpoint |
| `status_db_endpoint`        | status-service PostgreSQL endpoint       |
| `notification_db_endpoint`  | notification-service PostgreSQL endpoint |
| `postgres_port`             | PostgreSQL port (5432)                   |
| `db_username`               | PostgreSQL master username               |

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/terraform-db.yml`) runs automatically:

- **On pull request to `main`**: Runs `terraform init` and `terraform plan` (validation only)
- **On push to `main`**: Runs `terraform init`, `terraform plan`, and `terraform apply -auto-approve`
- **Manual trigger**: Supports `workflow_dispatch`

### Required GitHub Secrets

| Secret                 | Description                        |
|------------------------|------------------------------------|
| `AWS_ACCESS_KEY_ID`    | AWS Academy access key             |
| `AWS_SECRET_ACCESS_KEY`| AWS Academy secret key             |
| `AWS_SESSION_TOKEN`    | AWS Academy session token          |
| `DB_USERNAME`          | PostgreSQL master username         |
| `DB_PASSWORD`          | PostgreSQL master password         |

## Usage

### Apply manually (local)

```bash
cd terraform
terraform init
terraform plan -var="db_password=YOUR_PASSWORD"
terraform apply -var="db_password=YOUR_PASSWORD"
```

### Verify endpoints after apply

```bash
terraform output auth_db_endpoint
terraform output upload_db_endpoint
terraform output processor_db_endpoint
terraform output status_db_endpoint
terraform output notification_db_endpoint
```

## Technology Stack

- **Terraform** ~> 5.0 (AWS Provider)
- **AWS RDS** PostgreSQL 16.3
- **AWS VPC** Private subnets
- **S3** Remote state backend
- **GitHub Actions** CI/CD

## Acknowledgments

This project was developed with the assistance of [Claude](https://claude.com/claude-code) (Anthropic) as an AI pair-programming tool for code implementation, debugging, and documentation.
