provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.devops-prod-eks.token
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~>21.0"

  name    = "devops-prod-eks"
  kubernetes_version = "1.34"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  enable_irsa = true

  eks_managed_node_groups = {
    worker_group_node_1 = {
      instance_types = ["t3.micro"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
    worker_group_node_2 = {
      instance_types = ["t3.small"]
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
