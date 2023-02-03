locals {
  index_html = "${path.module}/index.html"
}
module "static_website" {

    source = "../."

    domain = "nahor.ml"

    force_destroy = true
    providers = {
      aws.us_east_1 = aws.us_east_1
    }
}

resource "aws_s3_bucket_object" "object" {
  bucket = module.static_website.domain
  key    = "index.html"
  source = local.index_html

  content_type = "text/html"

  metadata = {
    sha256 = filesha256(local.index_html)
  }
}
