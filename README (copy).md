# 🚀 Production-Grade DevOps Microservices Portfolio

[![Terraform](https://img.shields.io/badge/Terraform-1.7+-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.34-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io)
[![AWS EKS](https://img.shields.io/badge/AWS-EKS-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/eks/)
[![ArgoCD](https://img.shields.io/badge/GitOps-ArgoCD-EF7B4D?logo=argo&logoColor=white)](https://argoproj.github.io/cd/)
[![GitHub Actions](https://img.shields.io/badge/CI/CD-GitHub_Actions-2088FF?logo=github-actions&logoColor=white)](https://github.com/features/actions)
[![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker&logoColor=white)](https://docker.com)

> End-to-end microservices platform with secure CI/CD, GitOps, EKS on AWS, ALB Ingress, monitoring (Prometheus + Grafana), and custom domain via Cloudflare.

Live demo:  
**https://api.learndevops.site/products**  
**https://api.learndevops.site/orders**

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Microservices](#-microservices)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Infrastructure (Terraform + EKS)](#-infrastructure-terraform--eks)
- [GitOps with ArgoCD](#-gitops-with-argocd)
- [External Access (ALB + Cloudflare)](#-external-access-alb--cloudflare)
- [Monitoring (Prometheus + Grafana)](#-monitoring-prometheus--grafana)
- [Security & Best Practices](#-security--best-practices)
- [Cost Management](#-cost-management)
- [Skills Demonstrated](#-skills-demonstrated)
- [Screenshots](#-screenshots)
- [Getting Started](#-getting-started)
- [Cleanup](#-cleanup)
- [Future Improvements](#-future-improvements)
- [Author](#-author)

---

## 🎯 Overview

This project is a **real-world, production-grade microservices platform** built to demonstrate modern DevOps practices employers look for in 2026.

It includes:
- Secure CI/CD with GitHub Actions + OIDC (no long-lived secrets)
- Infrastructure as Code with Terraform (VPC + EKS)
- GitOps deployment with ArgoCD
- External access via AWS ALB Ingress + Cloudflare DNS & free SSL
- Monitoring with Prometheus + Grafana
- Custom domain (`api.learndevops.site`) for live demo

---

## 🏗️ Architecture

```mermaid
graph TD
    A[Developer / GitHub] -->|Push to main| B[GitHub Actions CI]
    B -->|Build & push images<br>OIDC auth, short SHA + :latest| C[Amazon ECR<br>Private repos: order-service, product-service]

    D[ArgoCD GitOps] -->|Auto-sync from Git<br>Self-heal & prune| E[AWS EKS Cluster<br>1.34, IRSA, managed node groups]

    E --> F[Pods: order-service<br>Go, 2–4 replicas]
    E --> G[Pods: product-service<br>FastAPI, 2 replicas]

    H[AWS Load Balancer Controller] -->|Provisions ALB| I[ALB Ingress<br>/products → product-service<br>/orders → order-service]

    J[Cloudflare DNS + Proxy] -->|HTTPS + DDoS protection| I

    K[Prometheus + Grafana<br>via kube-prometheus-stack] -->|Scrapes metrics| E

    L[External Users] -->|https://api.learndevops.site| J

    style A fill:#f9f,stroke:#333
    style C fill:#FF9900,stroke:#333,color:#fff
    style E fill:#527FFF,stroke:#333,color:#fff
    style I fill:#00A1D6,stroke:#333
    style K fill:#E652A0,stroke:#333
    style L fill:#4CAF50,stroke:#333,color:#fff



  

Data Flow

Developer pushes code → GitHub Actions builds & pushes images to ECR
ArgoCD detects Git change → syncs manifests to EKS
EKS pulls images → deploys pods
ALB routes traffic → external access via api.learndevops.site
Prometheus scrapes metrics → Grafana visualizes cluster + pod health

## Data Flow

1. Developer pushes code → GitHub Actions builds & pushes images to ECR
2. ArgoCD detects Git change → syncs manifests to EKS
3. EKS pulls images → deploys pods
4. ALB routes traffic → external access via `api.learndevops.site`
5. Prometheus scrapes metrics → Grafana visualizes cluster + pod health

## Tech Stack

| Category              | Technology                              | Purpose / Why Chosen                              |
|-----------------------|-----------------------------------------|---------------------------------------------------|
| Cloud                 | AWS (EKS, ECR, VPC, IAM, ALB)           | Enterprise standard, managed Kubernetes, deep integration |
| IaC                   | Terraform + Modules                     | Reproducible, state locking (S3/DynamoDB), modular |
| Container Registry    | Amazon ECR                              | Integrated with EKS, scan on push, free tier      |
| Orchestration         | Amazon EKS 1.34                         | Managed control plane, IRSA, addons (CNI, CoreDNS, EBS CSI) |
| CI/CD                 | GitHub Actions + OIDC                   | Secure (no secrets), matrix builds, path filtering |
| GitOps                | ArgoCD                                  | Declarative sync, auto-prune, self-heal, UI visibility |
| Ingress               | AWS Load Balancer Controller            | Provisions ALB, path-based routing                |
| Monitoring            | Prometheus + Grafana (via blueprints)   | Cluster + pod metrics, dashboards, alerts         |
| DNS & SSL             | Cloudflare (free proxy + universal SSL) | Fast DNS, free HTTPS, DDoS protection, no extra cost |
| Languages             | Go (order) + Python/FastAPI (product)   | Polyglot microservices demo                       |

## Project Structure

```text
devops-production-microservices/
├── services/                    # Microservice source code
│   ├── order/                   # Go service
│   └── product/                 # Python/FastAPI service
├── k8s/                         # Kubernetes manifests (Kustomize)
│   └── base/                    # Base manifests + kustomization.yaml
├── argocd/                      # ArgoCD configuration
│   └── applications/            # Application manifests
├── terraform/                   # Infrastructure as Code
│   ├── main.tf                  # Root module
│   ├── providers.tf
│   ├── outputs.tf
│   ├── vpc/
│   └── eks/
├── .github/workflows/           # CI/CD pipelines
└── README.md




## Services Overview

| Service  | Language       | Port | Path      | Description              |
|----------|----------------|------|-----------|--------------------------|
| Order    | Go             | 8080 | /orders   | Order processing API     |
| Product  | Python/FastAPI | 3000 | /products | Product catalog API      |

**Both services include:**

- Health endpoints (`/health`)
- Graceful shutdown
- Structured logging
- Resource limits & requests
- Non-root containers


## CI/CD Pipeline

- **Workflow file**: `.github/workflows/ci-build-push.yaml`
- **Triggers**: push / pull request to `main`
- **Authentication**: OIDC → secure AWS access (no secrets stored in GitHub)
- **Strategy**: matrix build → builds both services in parallel
- **Image tagging**: short commit SHA + `:latest`
- **Registry**: Amazon ECR


graph LR
    A[Push/PR to main] --> B[GitHub Actions]
    B --> C[Build Order (Go)]
    B --> D[Build Product (FastAPI)]
    C --> E[Push to ECR: order-service:abcdef1 + :latest]
    D --> F[Push to ECR: product-service:abcdef1 + :latest]
    E --> G[ArgoCD detects change → syncs to EKS]
    F --> G


## Infrastructure (Terraform + EKS)

- VPC: public + private subnets, NAT gateway
- EKS cluster: version 1.34
  - Public + private endpoint
  - IRSA enabled
- Node groups: `t3.medium`, 60 GiB gp3 volumes
- IAM policies for nodes: CNI, ECR pull, SSM, EBS CSI
- Add-ons (via blueprints): 
  - AWS Load Balancer Controller
  - Prometheus + Grafana

## GitOps with ArgoCD

- Watches: `k8s/base` folder in Git
- Auto-sync enabled
- Settings: `createNamespace=true`, `prune: true`, `selfHeal: true`
- Main Application manifest: `argocd/applications/microservices.yaml`

## External Access (ALB + Cloudflare)

- AWS Load Balancer Controller → provisions ALB from Ingress resource
- Cloudflare:
  - DNS: `api.learndevops.site`
  - Free proxy + SSL termination
- Routing:
  - `/products` → product-service
  - `/orders`   → order-service

## Monitoring (Prometheus + Grafana)

- Installed via `eks-blueprints-addons`
- Prometheus scrapes: cluster + pod metrics
- Grafana:
  - Default dashboards
  - Imported: Kubernetes Cluster, Node Exporter, Pod Metrics
  - Persistent storage enabled

**Temporary access:**

```bash
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80

→ open http://localhost:3000
(credentials: admin / your-password)

## Security & Best Practices

OIDC for GitHub Actions (no long-lived keys)
IRSA for pod-level permissions
Non-root containers
Resource requests & limits
Private subnets + NAT
ECR image scanning
Cloudflare proxy + free SSL

## Cost Management
EKS setup typically costs ~$70–150/month — destroy when not in use!
Bashcd terraform
terraform destroy -auto-approve

## Skills Demonstrated

Infrastructure as Code (Terraform + modules)
Secure CI/CD (GitHub Actions + OIDC)
GitOps (ArgoCD auto-sync, prune, self-heal)
Kubernetes (Deployments, Services, Ingress, Probes)
AWS EKS (IRSA, managed node groups, addons)
Monitoring (Prometheus + Grafana)
DNS + SSL (Cloudflare proxy)
Troubleshooting (CrashLoopBackOff, OOMKilled, IAM issues)


## Getting Started
**Prerequisites**

AWS account
Installed CLIs: aws, kubectl, terraform, helm, git

1. Clone & Configure
Bashgit clone https://github.com/elorm116/devops-production-microservices.git
cd devops-production-microservices
aws configure
2. Deploy Infrastructure
Bashcd terraform
terraform init
terraform apply

# Update kubeconfig
aws eks update-kubeconfig --region us-east-1 --name devops-prod-eks
3. Install ArgoCD
Bashkubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Access UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
→ open https://localhost:8080
(login: admin / auto-generated password)
4. Deploy Applications
ArgoCD auto-syncs from Git.
Manual sync possible via UI if needed.
5. Access Services
Bashkubectl get ingress microservices-ingress -n microservices

curl https://api.learndevops.site/products

## Cleanup
Bashcd terraform
terraform destroy -auto-approve

## Future Improvements
HTTPS with cert-manager + Let's Encrypt
Auto-scaling with Karpenter
CI/CD promotion pipeline (dev → staging → prod)
Chaos engineering tests






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
