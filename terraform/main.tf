module "vpc" {
  source          = "./vpc"
  vpc_cidr        = var.vpc_cidr
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

module "eks" {
  source          = "./eks"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  acm_certificate_arn = var.acm_certificate_arn
}
