variable "vpc_cidr" {}
variable "private_subnets" {
  type = list(string)
}
variable "public_subnets" {
  type = list(string)
}

data "aws_availability_zones" "azs" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = "devops-prod-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

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
