# DevOps QR Code Project

A production-grade microservices application deployed with an **Enterprise DevOps Stack**.

## 🚀 Tech Stack & Tools

This project showcases a complete DevSecOps pipeline and Cloud Native infrastructure:

| Domain | Technology | Description |
| :--- | :--- | :--- |
| **Cloud Provider** | **AWS** | EKS (Kubernetes), ECR, S3, VPC, IAM |
| **IaC** | **Terraform** | Automated infrastructure provisioning with remote state locking (DynamoDB) |
| **CI/CD** | **GitHub Actions** | Automated testing, security scanning, and container build/push |
| **GitOps** | **ArgoCD** | Continuous Delivery to Kubernetes with automated self-healing |
| **Containerization** | **Docker & Helm** | Optimized images and packaged Helm charts for K8s deployment |
| **Observability** | **Prometheus & Grafana** | Full stack monitoring, metrics collection, and visualization |
| **Security** | **IRSA** & **Trivy** | IAM Roles for Service Accounts (least privilege) and image scanning |
| **Local Testing** | **LocalStack** | Mocking AWS services locally for cost-efficient development |

## 🏗 Architecture

- **Frontend**: Next.js application served via Kubernetes Service.
- **Backend**: FastAPI (Python) service handling QR code generation.
- **Storage**: AWS S3 (mocked locally) for storing generated images.
- **Networking**: VPC with Public/Private subnets, NAT Gateways, and Ingress configurations.

---

### Quick Start (Dev Mode)
To run the full application (Frontend, Backend, and S3Mock) in Docker:
```bash
./scripts/start-app-docker.sh
```
- **Frontend**: http://localhost:3000
- **Backend**: http://localhost:8000
- **S3 Console**: http://localhost:9090

---

## 💻 Running Locally (DevOps Mode)

You can run the entire infrastructure stack locally without an AWS account using **LocalStack**.

### Prerequisites
- Docker & Docker Compose
- Python 3.11+ & Pip
- [Terraform](https://developer.hashicorp.com/terraform/install)

### Quick Start

1. **Setup Environment**
   We use `conda` or `venv` to manage tools like `tflocal` and `awscli-local`.
   ```bash
   conda create -n devops-qr-local python=3.11 -y
   conda activate devops-qr-local
   pip install terraform-local awscli-local
   ```

2. **Run Infrastructure Tests**
   Use the provided script to spin up LocalStack, provision mock S3 buckets, and verify the Terraform configuration.
   ```bash
   ./scripts/start-local-infra.sh
   ```
   *This command starts LocalStack, bootstraps the remote state backend, and runs `terraform plan` against the local environment.*
   *Note: Full `terraform apply` for EKS requires LocalStack Pro license.*

---

## 🛠 Running Application Locally (Dev Mode)

If you just want to run the code (Frontend + Backend) without the full infra:

### Backend (API)
1. `cd api`
2. `pip install -r requirements.txt`
3. `uvicorn main:app --reload`
   - Runs on: `http://localhost:8000`
   - *Note: Requires a local S3 Mock running (see docker-compose).*

### Frontend (Next.js)
1. `cd front-end-nextjs`
2. `npm install`
3. `npm run dev`
   - Runs on: `http://localhost:3000`

---

## 📜 License

[MIT](./LICENSE) - Copyright (c) 2023 Rishab Kumar, 2025 Daris Adam
