module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = "devops-prod-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_support   = true
  enable_dns_hostnames = true

  # EKS requires these tags for automatic subnet discovery
  tags = {
    Environment                               = "dev"
    Project                                   = "devops-production-microservices"
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }

  # Tags for private subnets - used for internal load balancers
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  # Tags for public subnets - used for internet-facing load balancers
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
}
