output "domain_validation_options" {
  description = "The domain validation options for the ACM certificate"
  value       = aws_acm_certificate.learndevops.domain_validation_options
  
}

output "certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = aws_acm_certificate.learndevops.arn
}

output "domain_name" {
  description = "The domain name for the ACM certificate"
  value       = aws_acm_certificate.learndevops.domain_name
}