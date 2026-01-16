variable "vpc_id" {}
variable "private_subnets" {
  type = list(string)
}
variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS"
  type        = string
}