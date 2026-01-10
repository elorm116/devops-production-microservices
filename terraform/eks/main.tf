module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~>21.0"

  name    = "devops-prod-eks"
  kubernetes_version = "1.34"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.micro"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }

  tags = {
    Environment = "dev"
    Project     = "devops-production-microservices"
  }
}
