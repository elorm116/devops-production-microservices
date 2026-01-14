variable "vpc_cidr" {}
variable "private_subnets" {}
variable "public_subnets" {}

data "aws_availability_zones" "azs" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.1"

  name = "myapp-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # EKS uses subnet tags for automatic discovery of networking resources. 
  # The kubernetes.io/cluster tag associates subnets with the cluster, while role/elb and role/internal-elb tell AWS where to place public and private load balancers for Kubernetes services.
  tags = {
    "kubernetes.io/cluster/devops-prod-eks" = "shared"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/devops-prod-eks" = "shared"
    "kubernetes.io/role/internal-elb"         = "1"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/devops-prod-eks" = "shared"
    "kubernetes.io/role/elb"                  = "1"
  }
}
