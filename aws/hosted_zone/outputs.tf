output "domain" {
  value = var.domain
}

output "name_servers" {
  value = aws_route53_zone.this.name_servers
}
