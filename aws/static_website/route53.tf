data "aws_route53_zone" "this" {
  name = var.hosted_zone_name != "" ? var.hosted_zone_name : var.domain
}

resource "aws_route53_record" "a_record" {

  zone_id = data.aws_route53_zone.this.zone_id

  name    = var.domain
  type    = "A"
  alias {
    name    = aws_cloudfront_distribution.this.domain_name
    zone_id = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false 
  }

}

resource "aws_route53_record" "cname_record" {

  zone_id = data.aws_route53_zone.this.zone_id

  name    = "*.${var.domain}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.this.domain_name]

}
