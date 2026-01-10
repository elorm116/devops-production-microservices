# Production-Grade DevOps Microservices Platform

[![Terraform](https://img.shields.io/badge/Terraform-1.7+-purple?logo=terraform)](https://terraform.io)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.34-blue?logo=kubernetes)](https://kubernetes.io)
[![AWS](https://img.shields.io/badge/AWS-EKS-orange?logo=amazon-aws)](https://aws.amazon.com/eks/)
[![Docker](https://img.shields.io/badge/Docker-Containerized-blue?logo=docker)](https://docker.com)

## 🎯 Project Overview

A **production-style microservices platform** demonstrating modern DevOps practices using AWS, Kubernetes (EKS), Terraform, Docker, GitHub Actions, and Jenkins.

This project showcases end-to-end infrastructure automation and CI/CD pipelines, reflecting real-world enterprise environments where teams work with multiple programming languages and deployment strategies.

### What This Project Demonstrates

- **Infrastructure as Code** — Full AWS infrastructure provisioned via Terraform modules
- **Container Orchestration** — Kubernetes deployments with resource limits, health checks, and rolling updates
- **CI/CD Pipelines** — Automated build, test, and deploy workflows
- **Multi-Language Microservices** — Polyglot architecture with Node.js, Python, and Go
- **Security Best Practices** — IAM roles, KMS encryption, private subnets, secret management
- **GitOps Workflow** — Infrastructure changes via pull requests with plan reviews

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                           AWS Cloud                                  │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                         VPC (10.0.0.0/16)                     │  │
│  │  ┌─────────────────────┐    ┌─────────────────────────────┐   │  │
│  │  │   Public Subnets    │    │     Private Subnets         │   │  │
│  │  │  ┌───────────────┐  │    │  ┌───────────────────────┐  │   │  │
│  │  │  │ NAT Gateway   │  │    │  │    EKS Node Group     │  │   │  │
│  │  │  │ Load Balancer │  │    │  │  ┌─────┐ ┌─────┐     │  │   │  │
│  │  │  └───────────────┘  │    │  │  │Auth │ │Order│     │  │   │  │
│  │  └─────────────────────┘    │  │  └─────┘ └─────┘     │  │   │  │
│  │                             │  │  ┌─────────┐         │  │   │  │
│  │                             │  │  │Product  │         │  │   │  │
│  │                             │  │  └─────────┘         │  │   │  │
│  │                             │  └───────────────────────┘  │   │  │
│  │                             └─────────────────────────────┘   │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐               │
│  │  ECR: auth   │  │ ECR: product │  │  ECR: order  │               │
│  └──────────────┘  └──────────────┘  └──────────────┘               │
└─────────────────────────────────────────────────────────────────────┘

         ▲                    ▲                    ▲
         │                    │                    │
    ┌────┴────────────────────┴────────────────────┴────┐
    │              GitHub Actions CI/CD                  │
    │  ┌────────────┐  ┌────────────┐  ┌────────────┐   │
    │  │ auth-ci    │  │ product-ci │  │ order-ci   │   │
    │  └────────────┘  └────────────┘  └────────────┘   │
    │  ┌─────────────────────────────────────────────┐  │
    │  │           terraform.yaml                    │  │
    │  │   (Plan → Review → Apply Infrastructure)    │  │
    │  └─────────────────────────────────────────────┘  │
    └───────────────────────────────────────────────────┘
```

### Tech Stack

| Category | Technology |
|----------|------------|
| **Cloud Provider** | AWS (EKS, ECR, VPC, IAM, KMS) |
| **Orchestration** | Kubernetes 1.34 |
| **Infrastructure as Code** | Terraform 1.7+ with modules |
| **CI/CD** | GitHub Actions + Jenkins |
| **Containerization** | Docker with multi-stage builds |
| **Languages** | Node.js, Python (FastAPI), Go |

---

## 📁 Project Structure

```
.
├── .github/workflows/          # GitHub Actions CI/CD pipelines
│   ├── auth-ci.yaml            # Auth service build & push
│   ├── order-ci.yaml           # Order service build & push
│   ├── product-ci.yaml         # Product service build & push
│   └── terraform.yaml          # Infrastructure automation
├── docker/                     # Dockerfiles for each service
│   ├── auth-node.Dockerfile
│   ├── order-go.Dockerfile
│   └── product-python.Dockerfile
├── k8s/                        # Kubernetes manifests
│   ├── deployments/            # Service deployments
│   ├── services/               # ClusterIP/LoadBalancer services
│   ├── ingress/                # Ingress rules
│   └── config/                 # ConfigMaps
├── services/                   # Microservice source code
│   ├── auth-node/              # Node.js authentication service
│   ├── order-go/               # Go order processing service
│   └── product-python/         # Python/FastAPI product catalog
├── terraform/                  # Infrastructure as Code
│   ├── main.tf                 # Root module
│   ├── variables.tf            # Input variables
│   ├── terraform.tfvars        # Variable values
│   ├── vpc/                    # VPC module
│   ├── eks/                    # EKS cluster module
│   ├── ecr/                    # Container registry module
│   └── backend/                # S3 state backend config
├── Jenkinsfile                 # Jenkins CD pipeline
└── README.md
```

---

## 🚀 Microservices

| Service | Language | Port | Purpose |
|---------|----------|------|---------|
| **auth-service** | Node.js | 3000 | User authentication & JWT tokens |
| **product-service** | Python/FastAPI | 3000 | Product catalog API |
| **order-service** | Go | 8080 | Order processing & management |

Each service:
- Has its own Dockerfile with multi-stage builds
- Includes health check endpoints
- Defines resource limits (CPU/memory)
- Is independently deployable via CI/CD

---

## 🔧 CI/CD Pipelines

### GitHub Actions Workflows

#### Service CI Pipelines (`auth-ci.yaml`, `product-ci.yaml`, `order-ci.yaml`)
- **Trigger**: Push to `services/<service-name>/**` or Dockerfile changes
- **Steps**: Checkout → AWS Auth → ECR Login → Build → Tag → Push
- **Tags**: Short SHA + `latest`

#### Terraform Pipeline (`terraform.yaml`)
- **On PR**: Validate → Plan → Post plan as PR comment
- **On Push to main**: Validate → Plan → Apply (requires approval)
- **Manual dispatch**: Plan, Apply, or Destroy

### Jenkins Pipeline (`Jenkinsfile`)
- Deploys to EKS using `kubectl set image`
- Verifies rollout with `kubectl rollout status`
- Supports parameterized builds for AWS Account ID

---

## 🏃 Getting Started

### Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.7.0
- kubectl
- Docker

### Deploy Infrastructure

```bash
# Clone the repository
git clone https://github.com/<your-username>/devops-production-microservices.git
cd devops-production-microservices/terraform

# Initialize and apply
terraform init
terraform plan
terraform apply
```

### Configure kubectl

```bash
aws eks update-kubeconfig --region us-east-1 --name devops-prod-eks
```

### Deploy Services

```bash
# Apply Kubernetes manifests
kubectl apply -f k8s/deployments/
kubectl apply -f k8s/services/
kubectl apply -f k8s/ingress/
```

### Run Locally (Development)

```bash
# Auth service
cd services/auth-node && npm install && npm start

# Product service
cd services/product-python && pip install -r requirements.txt && uvicorn main:app --reload

# Order service
cd services/order-go && go run main.go
```

---

## 🔒 Security Considerations

- **Private Subnets**: Worker nodes run in private subnets
- **NAT Gateway**: Outbound internet access without public IPs
- **KMS Encryption**: EKS secrets encrypted at rest
- **IAM Roles**: Least-privilege access for nodes and CI/CD
- **Secret Management**: Credentials stored in GitHub Secrets / Jenkins credentials
- **Resource Limits**: Prevents noisy neighbor issues in pods

---

## 💰 Cost Optimization

This project is designed for **learning and demonstration**:

- Infrastructure is destroyed after demos to minimize costs
- Uses `t3.micro` and `t3.small` instances
- Single NAT Gateway (not HA) to reduce costs
- Can scale up for production workloads

**Estimated cost**: ~$70-100/month when running

---

## 📈 Future Improvements

- [ ] Add Prometheus + Grafana monitoring
- [ ] Implement service mesh (Istio/Linkerd)
- [ ] Add database layer (RDS/DynamoDB)
- [ ] Implement GitOps with ArgoCD
- [ ] Add Ansible for configuration management
- [ ] Implement blue/green deployments
- [ ] Add automated security scanning (Trivy, Snyk)

---

## 🎓 Skills Demonstrated

This project showcases proficiency in:

- **Cloud Platforms**: AWS (EKS, ECR, VPC, IAM, KMS, S3)
- **Container Orchestration**: Kubernetes (Deployments, Services, Ingress, ConfigMaps)
- **Infrastructure as Code**: Terraform (modules, state management, workspaces)
- **CI/CD**: GitHub Actions, Jenkins
- **Containerization**: Docker (multi-stage builds, optimization)
- **Programming**: Node.js, Python, Go
- **Networking**: VPC design, subnets, NAT, load balancing
- **Security**: IAM, secrets management, encryption

---

## 📄 License

This project is for educational and portfolio purposes.

---

## 👤 Author

**[Your Name]**
- LinkedIn: [your-linkedin]
- GitHub: [your-github]
- Email: aezottor.@gmail.com

---

*Built as a portfolio project demonstrating production-grade DevOps practices.*
