module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "devops-prod-eks"
  kubernetes_version = "1.34"

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  enable_irsa = true

  endpoint_public_access  = true
  endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  eks_managed_node_groups = {
    worker_group_1 = {
      min_size       = 2
      max_size       = 4
      desired_size   = 2
      instance_types = ["t3.medium"]
    }
  }

  tags = {
    environment = "dev"
    application = "devops-production-microservices"
  }
}

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.21"

  depends_on = [module.eks]

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_aws_load_balancer_controller = true
  enable_kube_prometheus_stack        = true

  aws_load_balancer_controller = {
    chart         = "aws-load-balancer-controller"
    chart_version = "1.17.1"
    repository    = "https://aws.github.io/eks-charts"
    namespace     = "kube-system"
    wait          = true
    wait_for_jobs = true
    values = [
      yamlencode({
        clusterName = module.eks.cluster_name
        region      = "us-east-1"
        vpcId       = var.vpc_id
        replicaCount = 2
      })
    ]
  }

  kube_prometheus_stack = {
    chart         = "kube-prometheus-stack"
    chart_version = "80.14.3"
    repository    = "https://prometheus-community.github.io/helm-charts"
    namespace     = "monitoring"
    wait          = true
    wait_for_jobs = true
    values = [
      yamlencode({
        grafana = {
          adminPassword = "admin"
          ingress = {
            enabled          = true
            ingressClassName = "alb"
            annotations = {
              "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
              "alb.ingress.kubernetes.io/target-type"     = "ip"
              "alb.ingress.kubernetes.io/certificate-arn" = var.acm_certificate_arn
              "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
              "alb.ingress.kubernetes.io/ssl-redirect" = "443"
            }
            hosts = ["grafana.learndevops.site"]
            path  = "/"
          }
        }
        prometheus = {
          prometheusSpec = {
            serviceMonitorSelectorNilUsesHelmValues = false
            serviceMonitorSelector = {
              matchLabels = {
                "release" = "kube-prometheus-stack"
              }
            }
          }
        }
      })
    ]
  }


    tags = {
        environment = "dev"
        application = "devops-production-microservices"
    }
}