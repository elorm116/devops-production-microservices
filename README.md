# Production-Grade DevOps Microservices Platform

## Overview
This project proves to demonstrates a production-style DevOps platform using
AWS, Kubernetes (EKS), Terraform, Docker, GitHub Actions, and Jenkins.

The system deploys multiple microservices written in different languages
to reflect real-world, team-oriented development environments.

## Architecture
- Cloud Provider: AWS
- Orchestration: Kubernetes (EKS)
- Infrastructure as Code: Terraform
- CI: GitHub Actions
- CD: Jenkins
- Container Registry: Amazon ECR

## Design Constraints
- Infrastructure is created and destroyed on demand to control cost
- Architecture prioritizes clarity, automation, and security over scale
- Decisions are documented with production trade-offs in mind

## Microservices
- Auth Service (Node.js)
- Product Service (Python / FastAPI)
- Order Service (Go)

## Status
🚧 Project under active development
