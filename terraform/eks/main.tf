data "aws_eks_cluster_auth" "main" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.main.token
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

    # Enable cluster endpoint access
   endpoint_public_access  = true
   endpoint_private_access = true
   
   # Adds current IAM user as admin to the cluster
   enable_cluster_creator_admin_permissions = true

  addons = {
    coredns            = {}
    kube-proxy         = {}
    vpc-cni            = {}
    aws-ebs-csi-driver = {}
  }

  eks_managed_node_groups = {
    worker_group_node_1 = {
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2

      capacity_type = "SPOT"
    }
  }

  tags = {
    Environment = "dev"
    Project     = "devops-production-microservices"
  }
}
