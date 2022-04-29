output "url" {
  value = "https://${aws_route53_record.a_record.name}"
}

output "domain" {
  value = var.domain
}