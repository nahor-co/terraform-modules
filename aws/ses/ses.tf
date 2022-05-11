data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "this" {
  name = var.domain
}

resource "aws_ses_domain_identity" "this" {
  domain = var.domain
}

# DKIM
resource "aws_ses_domain_dkim" "this" {
  domain = aws_ses_domain_identity.this.domain
}

## CNAME is for DKIM
resource "aws_route53_record" "dkim_cname" {
  count   = 3
  zone_id = data.aws_route53_zone.this.id
  name    = "${element(aws_ses_domain_dkim.this.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.this.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

## custom domain MAIL FROM
resource "aws_ses_domain_mail_from" "this" {
  domain           = aws_ses_domain_identity.this.domain
  mail_from_domain = "bounce-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}.${aws_ses_domain_identity.this.domain}"
}

# MX custom domain MAIL FROM
resource "aws_route53_record" "mail_from_mx" {
  zone_id = data.aws_route53_zone.this.id
  name    = aws_ses_domain_mail_from.this.mail_from_domain
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.${data.aws_region.current.name}.amazonses.com"]
}

# TXT custom domain MAIL FROM
resource "aws_route53_record" "mail_from_txt" {
  zone_id = data.aws_route53_zone.this.id
  name    = aws_ses_domain_mail_from.this.mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

