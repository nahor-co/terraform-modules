resource "aws_s3_bucket" "instance" {

  bucket = var.bucket
  force_destroy = var.force_destroy

  #checkov:skip=CKV_AWS_21: versioning not required
  #checkov:skip=CKV_AWS_144: cross region replication not required 
  #checkov:skip=CKV_AWS_145: aws managed key sufficent for encryption
  #checkov:skip=CKV_AWS_18: access logs not required 

}

resource "aws_s3_bucket_server_side_encryption_configuration" "instance" {

  bucket = aws_s3_bucket.instance.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

resource "aws_s3_bucket_acl" "instance" {

  bucket = aws_s3_bucket.instance.id
  acl    = var.acl
}

resource "aws_s3_bucket_public_access_block" "instance" {

  count = var.acl == "private" ? 1 : 0

  bucket = aws_s3_bucket.instance.id

  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true

}
