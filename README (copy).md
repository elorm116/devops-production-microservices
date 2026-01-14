# 🚀 Production-Grade DevOps Microservices Platform

[![Terraform](https://img.shields.io/badge/Terraform-1.7+-purple?logo=terraform)](https://terraform.io)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.34-blue?logo=kubernetes)](https://kubernetes.io)
[![AWS](https://img.shields.io/badge/AWS-EKS-orange?logo=amazon-aws)](https://aws.amazon.com/eks/)
[![Docker](https://img.shields.io/badge/Docker-Containerized-blue?logo=docker)](https://docker.com)
[![GitHub Actions](https://img.shields.io/badge/CI-GitHub%20Actions-2088FF?logo=github-actions)](https://github.com/features/actions)
[![ArgoCD](https://img.shields.io/badge/GitOps-ArgoCD-EF7B4D?logo=argo)](https://argoproj.github.io/cd/)

> A modern, production-grade microservices portfolio project demonstrating real-world DevOps practices with AWS, Kubernetes, Terraform, and GitOps.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Microservices](#-microservices)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Getting Started](#-getting-started)
- [Screenshots](#-screenshots)
- [Security](#-security-considerations)
- [Cost Optimization](#-cost-optimization)
- [Skills Demonstrated](#-skills-demonstrated)
- [Future Improvements](#-future-improvements)
- [Cleanup](#-cleanup)
- [Author](#-author)

---

## 🎯 Overview

This project showcases **end-to-end infrastructure automation and CI/CD pipelines**, reflecting real-world enterprise environments where teams work with multiple programming languages and deployment strategies.

### What This Project Demonstrates

| Skill | Implementation |
|-------|----------------|
| **Infrastructure as Code** | Full AWS infrastructure provisioned via Terraform modules |
| **Container Orchestration** | Kubernetes deployments with resource limits, health checks, rolling updates |
| **CI/CD Pipelines** | GitHub Actions with OIDC authentication (no long-lived secrets) |
| **GitOps** | ArgoCD for declarative, self-healing deployments from Git |
| **Multi-Language Microservices** | Polyglot architecture with Go and Python |
| **Security Best Practices** | OIDC, IRSA, non-root containers, least-privilege IAM |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              DEVELOPER WORKFLOW                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            GitHub Repository                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ services/   │  │ k8s/        │  │ terraform/  │  │ .github/workflows/ │ │
│  │ order/      │  │ base/       │  │ vpc/        │  │ ci-build-push.yaml │ │
│  │ product/    │  │ overlays/   │  │ eks/        │  │                    │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
         │                    │                │
         │ push/PR            │ sync           │ terraform apply
         ▼                    ▼                ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────────────────┐
│ GitHub Actions  │  │    ArgoCD       │  │            AWS Cloud                │
│ ┌─────────────┐ │  │ ┌─────────────┐ │  │  ┌─────────────────────────────────┐│
│ │ Build Order │ │  │ │ Auto-Sync   │ │  │  │         VPC (10.0.0.0/16)       ││
│ │ Build Prod. │ │  │ │ Self-Heal   │ │  │  │  ┌───────────┐  ┌───────────┐  ││
│ │ Push to ECR │ │  │ │ Prune Old   │ │  │  │  │  Public   │  │  Private  │  ││
│ └─────────────┘ │  │ └─────────────┘ │  │  │  │  Subnets  │  │  Subnets  │  ││
└────────┬────────┘  └────────┬────────┘  │  │  └─────┬─────┘  └─────┬─────┘  ││
         │                    │           │  │        │ NAT          │        ││
         ▼                    │           │  │        ▼              ▼        ││
┌─────────────────┐           │           │  │  ┌─────────────────────────┐   ││
│   Amazon ECR    │           │           │  │  │     EKS Cluster         │   ││
│ ┌─────────────┐ │           │           │  │  │  ┌──────┐  ┌──────┐    │   ││
│ │order:abc123 │ │           └──────────────┼──┼─▶│Order │  │Prod. │    │   ││
│ │prod.:def456 │ │◀──────────────────────┼──┼──│  │ Pod  │  │ Pod  │    │   ││
│ └─────────────┘ │                       │  │  │  └──────┘  └──────┘    │   ││
└─────────────────┘                       │  │  └───────────┬─────────────┘   ││
                                          │  │              │                  ││
                                          │  │              ▼                  ││
                                          │  │  ┌─────────────────────────┐   ││
                                          │  │  │  AWS Load Balancer      │   ││
                                          │  │  │  (ALB Ingress)          │   ││
                                          │  │  └───────────┬─────────────┘   ││
                                          │  └──────────────┼──────────────────┘│
                                          └─────────────────┼───────────────────┘
                                                            ▼
                                                    🌐 External Traffic
                                                    /orders  /products
```

### Data Flow

1. **Developer pushes code** → GitHub triggers CI workflow
2. **GitHub Actions** → Builds Docker images, tags with short SHA, pushes to ECR
3. **ArgoCD watches Git** → Detects manifest changes, syncs to EKS
4. **EKS pulls images** → Deploys pods with new versions
5. **ALB routes traffic** → External access via path-based routing

---

## 🛠️ Tech Stack

| Category | Technology | Why This Choice |
|----------|------------|-----------------|
| **Cloud** | AWS (EKS, ECR, VPC, IAM) | Enterprise-standard, managed Kubernetes, deep integration |
| **Orchestration** | Amazon EKS 1.34 | Managed control plane, IRSA support, managed addons |
| **Infrastructure** | Terraform + Modules | Reproducible, state locking (S3/DynamoDB), reusable |
| **CI/CD** | GitHub Actions + OIDC | Secure (no long-lived secrets), native to repo |
| **GitOps** | ArgoCD | Declarative sync, auto-prune, self-heal, great UI |
| **Registry** | Amazon ECR | Integrated with EKS, image scanning, free tier |
| **Ingress** | AWS Load Balancer Controller | Provisions ALB, path-based routing |
| **Containers** | Docker | Multi-stage builds, minimal images |

---

## 📁 Project Structure

```
devops-production-microservices/
│
├── 📂 services/                    # Microservice source code
│   ├── order/                      # Go order service
│   │   ├── Dockerfile
│   │   ├── main.go
│   │   └── go.mod
│   └── product/                    # Python FastAPI service
│       ├── Dockerfile
│       ├── main.py
│       └── requirements.txt
│
├── 📂 k8s/                         # Kubernetes manifests
│   └── base/                       # Kustomize base
│       ├── kustomization.yaml
│       ├── deployments/
│       │   ├── order.yaml
│       │   └── product.yaml
│       ├── services/
│       ├── ingress/
│       └── config/
│
├── 📂 argocd/                      # GitOps configuration
│   ├── applications/
│   │   └── microservices.yaml      # ArgoCD Application
│   └── projects/
│
├── 📂 terraform/                   # Infrastructure as Code
│   ├── main.tf                     # Root module
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── providers.tf
│   ├── vpc/                        # VPC module
│   ├── eks/                        # EKS cluster module
│   └── ecr/                        # Container registry module
│
├── 📂 .github/workflows/           # CI/CD pipelines
│   ├── order-ci.yaml
│   ├── product-ci.yaml
│   └── terraform.yaml
│
├── 📂 docs/                        # Documentation
│   ├── adrs/                       # Architecture Decision Records
│   ├── diagrams/
│   └── screenshots/
│
└── README.md
```

---

## 🔧 Microservices

| Service | Language | Port | Endpoint | Description |
|---------|----------|------|----------|-------------|
| **Order** | Go | 8080 | `/orders` | Order processing and management |
| **Product** | Python/FastAPI | 3000 | `/products` | Product catalog API |

### Service Features

- ✅ Health check endpoints (`/health`, `/ready`)
- ✅ Structured JSON logging
- ✅ Graceful shutdown handling
- ✅ Resource limits (CPU/memory)
- ✅ Non-root container execution
- ✅ Multi-stage Docker builds

---

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Push to    │───▶│  Build &     │───▶│   Push to    │───▶│   ArgoCD     │
│   GitHub     │    │  Test        │    │   ECR        │    │   Syncs      │
└──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
                           │
                           ▼
                    ┌──────────────┐
                    │ Matrix Build │
                    │ order + prod │
                    └──────────────┘
```

### Key Features

| Feature | Description |
|---------|-------------|
| **OIDC Authentication** | No long-lived AWS secrets stored in GitHub |
| **Matrix Builds** | Parallel builds for all services |
| **Path Filtering** | Only build services that changed |
| **Short SHA Tags** | Traceable image versions (e.g., `abc123f`) |
| **Automatic `latest`** | Convenience tag for development |

### Terraform Pipeline

| Trigger | Action |
|---------|--------|
| **Pull Request** | `terraform plan` → Post plan as PR comment |
| **Push to main** | `terraform apply` (requires approval) |
| **Manual** | Plan, Apply, or Destroy via workflow dispatch |

---

## 🚀 Getting Started

### Prerequisites

```bash
# Required tools
aws --version        # AWS CLI v2
kubectl version      # Kubernetes CLI
terraform version    # Terraform >= 1.5
helm version         # Helm 3
git --version
```

### 1. Clone & Configure

```bash
git clone https://github.com/elorm116/devops-production-microservices.git
cd devops-production-microservices

# Configure AWS credentials
aws configure
```

### 2. Deploy Infrastructure (~20 minutes)

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 3. Configure kubectl

```bash
aws eks update-kubeconfig --region us-east-1 --name devops-prod-eks
kubectl get nodes  # Verify connection
```

### 4. Install ArgoCD

```bash
# Create namespace and install
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for deployment
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s

# Get initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Access UI (localhost:8080)
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### 5. Deploy Applications

ArgoCD automatically syncs from Git. For manual sync:
- Open ArgoCD UI → Applications → `microservices` → **Sync**

### 6. Access Services

```bash
# Get ALB hostname
kubectl get ingress microservices-ingress -n microservices

# Test endpoints
curl http://<alb-hostname>/products
curl http://<alb-hostname>/orders
```

### Local Development

```bash
# Order service (Go)
cd services/order
go run main.go

# Product service (Python)
cd services/product
pip install -r requirements.txt
uvicorn main:app --reload --port 3000
```

---

## 📸 Screenshots

<details>
<summary>Click to expand screenshots</summary>

### GitHub Actions CI
![CI Success](docs/screenshots/ci-success.png)
*Matrix builds for order & product services*

### Amazon ECR
![ECR Images](docs/screenshots/ecr-images.png)
*Short SHA + latest tags for each service*

### ArgoCD Dashboard
![ArgoCD Synced](docs/screenshots/argocd-synced.png)
*Synced application with health status*

### Running Pods
![Pods Running](docs/screenshots/pods-running.png)
*kubectl get pods output*

### ALB Ingress
![ALB Hostname](docs/screenshots/alb-hostname.png)
*External access via AWS Load Balancer*

</details>

---

## 🔒 Security Considerations

| Security Measure | Implementation |
|------------------|----------------|
| **No Long-Lived Secrets** | OIDC for GitHub Actions → AWS authentication |
| **IRSA** | IAM Roles for Service Accounts (pod-level permissions) |
| **Private Subnets** | Worker nodes have no public IPs |
| **Non-Root Containers** | All pods run as non-root users |
| **Resource Limits** | Prevents noisy neighbor issues |
| **KMS Encryption** | EKS secrets encrypted at rest |
| **Network Policies** | Restrict pod-to-pod communication |
| **Image Scanning** | ECR scans on push for vulnerabilities |

---

## 💰 Cost Optimization

This project is designed for **learning and demonstration**:

| Strategy | Savings |
|----------|---------|
| Destroy when not in use | ~$70-100/month saved |
| `t3.small` / `t3.medium` instances | Cost-effective for demos |
| Single NAT Gateway | ~$30/month saved (not HA) |
| Spot instances available | Up to 70% savings |

**⚠️ Important**: Always run `terraform destroy` when done!

---

## 🎓 Skills Demonstrated

This project showcases proficiency in:

### Cloud & Infrastructure
- ☁️ **AWS**: EKS, ECR, VPC, IAM, KMS, S3, ALB
- 🏗️ **Terraform**: Modules, state management, workspaces

### Containers & Orchestration
- 🐳 **Docker**: Multi-stage builds, optimization, security
- ☸️ **Kubernetes**: Deployments, Services, Ingress, ConfigMaps, RBAC

### CI/CD & GitOps
- 🔄 **GitHub Actions**: Matrix builds, OIDC, path filtering
- 🎯 **ArgoCD**: Declarative deployments, auto-sync, self-heal

### Programming
- 🐹 **Go**: HTTP servers, structured logging
- 🐍 **Python**: FastAPI, async programming

### Networking & Security
- 🌐 VPC design, subnets, NAT, load balancing
- 🔐 OIDC, IRSA, secrets management, least-privilege

---

## 📈 Future Improvements

- [ ] 📊 Add Prometheus + Grafana monitoring stack
- [ ] 🔀 Implement service mesh (Istio/Linkerd)
- [ ] 💾 Add database layer (RDS/DynamoDB)
- [ ] 🔐 External Secrets Operator for secrets management
- [ ] 📜 cert-manager + ExternalDNS for TLS/DNS
- [ ] 🔵 Blue/green and canary deployments
- [ ] 🛡️ Automated security scanning (Trivy, Snyk)
- [ ] 📝 Architecture Decision Records (ADRs)
- [ ] 🎥 Demo video walkthrough

---

## 🧹 Cleanup

**⚠️ Important**: EKS costs ~$70-150/month. Always destroy when done!

```bash
# Delete ArgoCD applications first
kubectl delete -n argocd -f argocd/applications/

# Destroy infrastructure
cd terraform
terraform destroy -auto-approve
```

Verify in AWS Console that all resources are deleted.

---

## 📄 License

This project is for **educational and portfolio purposes**.

---

## 👤 Author

**Anthony Elorm Zottor**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin)](https://www.linkedin.com/in/aezottor/)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?logo=github)](https://github.com/elorm116)
[![Email](https://img.shields.io/badge/Email-Contact-red?logo=gmail)](mailto:aezottor@gmail.com)

---

<div align="center">

**⭐ If you found this project helpful, please give it a star!**

*Built with ☕ and determination as a portfolio project demonstrating production-grade DevOps practices.*

🚀 Happy Deploying!

</div>
