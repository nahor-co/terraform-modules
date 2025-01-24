resource "aws_cloudfront_distribution" "this" {

  enabled = true

  aliases = ["*.${var.domain}", var.domain]

  default_root_object = var.root_object
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket.instance.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.instance.bucket_regional_domain_name

  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.this.certificate_arn
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  restrictions {
    geo_restriction { 
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    cache_policy_id  = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    target_origin_id = aws_s3_bucket.instance.bucket_regional_domain_name

    viewer_protocol_policy = "redirect-to-https"

    dynamic "lambda_function_association" {
      for_each = var.viewer_request_lambda_arn != "" ? ["force-loop"] : []
      content {
        event_type   = "viewer-request"
        lambda_arn   = var.viewer_request_lambda_arn
        include_body = false
      }
    }
  }

}

resource "aws_acm_certificate" "this" {
  domain_name       = var.domain
  subject_alternative_names = ["*.${var.domain}"]

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.us_east_1
}

resource "aws_route53_record" "this" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.zone_id
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.this : record.fqdn]

  provider = aws.us_east_1
}
