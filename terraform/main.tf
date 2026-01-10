module "vpc" {
  source = "./vpc"
}

module "eks" {
  source          = "./eks"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}
