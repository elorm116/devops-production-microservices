provider "aws" {
  region = "us-east-1"
}


resource "aws_acm_certificate" "learndevops" {
    domain_name       = "*.learndevops.site"
    validation_method = "DNS"
    
    tags = {
        Name = "learndevops-site-cert"
    }
}