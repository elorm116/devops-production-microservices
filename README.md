# 🚀 Production-Grade DevOps Microservices Portfolio

[![Terraform](https://img.shields.io/badge/Terraform-1.7+-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.34-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io)
[![AWS EKS](https://img.shields.io/badge/AWS-EKS-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/eks/)
[![ArgoCD](https://img.shields.io/badge/GitOps-ArgoCD-EF7B4D?logo=argo&logoColor=white)](https://argoproj.github.io/cd/)
[![GitHub Actions](https://img.shields.io/badge/CI/CD-GitHub_Actions-2088FF?logo=github-actions&logoColor=white)](https://github.com/features/actions)
[![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker&logoColor=white)](https://docker.com)

> End-to-end microservices platform with secure CI/CD, GitOps, EKS on AWS, ALB Ingress, monitoring (Prometheus + Grafana), and custom domain via Cloudflare.

**Live Demo:**  
(Down now because I am saving cost on AWS)
🔗 https://api.learndevops.site/products  
🔗 https://api.learndevops.site/orders

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

This project is a **real-world, production-grade microservices platform** built to demonstrate modern DevOps practices.

It includes:
- Secure CI/CD with GitHub Actions + OIDC (no long-lived secrets)
- Infrastructure as Code with Terraform (VPC + EKS)
- GitOps deployment with ArgoCD
- External access via AWS ALB Ingress + Cloudflare DNS & free SSL
- Monitoring with Prometheus + Grafana
- Custom domain (`api.learndevops.site`)

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
```

### Data Flow

1. Developer pushes code → GitHub Actions builds & pushes images to ECR
2. ArgoCD detects Git change → syncs manifests to EKS
3. EKS pulls images → deploys pods
4. ALB routes traffic → external access via api.learndevops.site
5. Prometheus scrapes metrics → Grafana visualizes cluster + pod health

---

## 🛠️ Tech Stack

| Category | Technology | Purpose / Why Chosen |
|----------|------------|----------------------|
| Cloud | AWS (EKS, ECR, VPC, IAM, ALB) | Enterprise standard, managed Kubernetes, deep integration |
| IaC | Terraform + Modules | Reproducible, state locking (S3/DynamoDB), modular |
| Container Registry | Amazon ECR | Integrated with EKS, scan on push, free tier |
| Orchestration | Amazon EKS 1.34 | Managed control plane, IRSA, addons (CNI, CoreDNS, EBS CSI) |
| CI/CD | GitHub Actions + OIDC | Secure (no secrets), matrix builds, path filtering |
| GitOps | ArgoCD | Declarative sync, auto-prune, self-heal, UI visibility |
| Ingress | AWS Load Balancer Controller | Provisions ALB, path-based routing, integrates with Route 53 |
| Monitoring | Prometheus + Grafana (via blueprints) | Cluster + pod metrics, dashboards, alerts |
| DNS & SSL | Cloudflare (free proxy + universal SSL) | Fast DNS, free HTTPS, DDoS protection, no extra cost |
| Languages | Go (order) + Python/FastAPI (product) | Polyglot microservices demo |

---

## 📁 Project Structure

```
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
```

---

## 🔧 Microservices

| Service | Language | Port | Path | Description |
|---------|----------|------|------|-------------|
| Order | Go | 8080 | /orders | Order processing API |
| Product | Python/FastAPI | 3000 | /products | Product catalog API |

Both services include:
- Health endpoints (`/health`)
- Graceful shutdown
- Structured logging
- Resource limits & requests
- Non-root containers

---

## 🔄 CI/CD Pipeline

**GitHub Actions Workflow** (`.github/workflows/ci-build-push.yaml`)

- Triggers on push/PR to main
- Uses OIDC for secure AWS access (no secrets in GitHub)
- Matrix strategy: builds both services in parallel
- Tags images with short SHA + `:latest`
- Pushes to Amazon ECR

```mermaid
graph LR
    A[Push/PR to main] --> B[GitHub Actions]
    B --> C[Build Order - Go]
    B --> D[Build Product - FastAPI]
    C --> E[Push to ECR: order-service:abcdef1 + :latest]
    D --> F[Push to ECR: product-service:abcdef1 + :latest]
    E --> G[ArgoCD detects change → syncs to EKS]
    F --> G
```

---

## ☸️ Infrastructure (Terraform + EKS)

**`terraform/main.tf`** (simplified)

- VPC with public/private subnets, NAT gateway
- EKS cluster (1.34) with IRSA, public/private endpoint
- Managed node groups (t3.medium, 60 GiB gp3 volumes)
- IAM policies for nodes (CNI, ECR, SSM, EBS CSI)
- Blueprints addons module for ALB Controller + Prometheus/Grafana

> ⚠️ **Cost awareness:** ~$70–150/month when running — always destroy after demos.

---

## 🎯 GitOps with ArgoCD

- ArgoCD watches `k8s/base` in Git
- Auto-syncs Deployments, Services, Ingress
- `CreateNamespace=true` + `prune: true` + `selfHeal: true`
- Application manifest: `argocd/applications/microservices.yaml`

```yaml
spec:
  source:
    repoURL: https://github.com/elorm116/devops-production-microservices.git
    targetRevision: main
    path: k8s/base
  destination:
    namespace: microservices
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

---

## 🌐 External Access (ALB + Cloudflare)

- AWS Load Balancer Controller provisions ALB from Ingress
- Cloudflare DNS + free proxy/SSL for `api.learndevops.site`
- Paths: `/products` → product-service, `/orders` → order-service

```yaml
# k8s/base/ingress/ingress.yaml
spec:
  ingressClassName: alb
  rules:
    - host: api.learndevops.site
      http:
        paths:
          - path: /products
            backend:
              service:
                name: product-service
                port: 80
          - path: /orders
            backend:
              service:
                name: order-service
                port: 80
```

---

## 📊 Monitoring (Prometheus + Grafana)

- Enabled via `eks-blueprints-addons`
- Prometheus scrapes cluster + pod metrics
- Grafana with default + imported dashboards (Kubernetes Cluster, Node Exporter, Pod Metrics)
- Persistent storage for data retention

**Access (temporary):**

```bash
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80
# → http://localhost:3000 (admin / your-password)
```

---

## 🔒 Security & Best Practices

- ✅ OIDC for GitHub Actions → no long-lived keys
- ✅ IRSA for pod permissions
- ✅ Non-root containers
- ✅ Resource requests/limits
- ✅ Private subnets + NAT
- ✅ Image scanning in ECR
- ✅ Cloudflare proxy + free SSL

---

## 💰 Cost Management

> ⚠️ EKS can cost ~$70–150/month — always destroy when done!

```bash
cd terraform
terraform destroy -auto-approve
```

---

## 🎓 Skills Demonstrated

- ✅ Infrastructure as Code (Terraform + modules)
- ✅ Secure CI/CD (GitHub Actions + OIDC)
- ✅ GitOps (ArgoCD auto-sync, prune, self-heal)
- ✅ Kubernetes (Deployments, Services, Ingress, Probes)
- ✅ AWS EKS (IRSA, managed node groups, addons)
- ✅ Monitoring (Prometheus + Grafana)
- ✅ DNS + SSL (Cloudflare proxy)
- ✅ Troubleshooting (CrashLoopBackOff, OOMKilled, IAM issues)

---

## 📸 Screenshots

<!-- Add your screenshots here -->

---

## 🧹 Cleanup

```bash
# Delete ArgoCD apps first
kubectl delete -n argocd -f argocd/applications/

# Destroy infrastructure
cd terraform
terraform destroy -auto-approve
```

---

## 👤 Author

**Anthony Elorm Zottor**

Portfolio project demonstrating modern DevOps practices.

[![GitHub](https://img.shields.io/badge/GitHub-elorm116-181717?logo=github)](https://github.com/elorm116)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?logo=linkedin)](https://linkedin.com)

---

*Built with determination and coffee ☕*

⭐ **If this helped you, please star the repo!**

---

## 🚀 Happy Deploying!
