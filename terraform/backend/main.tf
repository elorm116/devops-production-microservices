terraform {
    required_version = ">= 1.0.0"
  backend "s3" {
    bucket         = "devops-terraform-state-example"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
