resource "aws_s3_bucket" "instance" {

  bucket = var.domain
  force_destroy = var.force_destroy

  #checkov:skip=CKV_AWS_21: versioning not required
  #checkov:skip=CKV_AWS_144: cross region replication not required 
  #checkov:skip=CKV_AWS_145: aws managed key sufficent for encryption
  #checkov:skip=CKV_AWS_18: access logs not required 

}

resource "aws_s3_bucket_server_side_encryption_configuration" "instance" {

  bucket = aws_s3_bucket.instance.id

  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

resource "aws_s3_bucket_policy" "instance" {

  bucket = aws_s3_bucket.instance.id
  
  policy = jsonencode(
            {
              Statement = [
                {
                  Action    = "s3:GetObject"
                  Effect    = "Allow"
                  Principal = "*"
                  Resource  = "arn:aws:s3:::${aws_s3_bucket.instance.bucket}/*"
                  Sid       = "PublicReadGetObject"
                },
              ]
              Version   = "2012-10-17"
            }
  )

}

resource "aws_s3_bucket_website_configuration" "instance" {
  bucket = aws_s3_bucket.instance.bucket

  index_document {
    suffix = var.root_object
  }
}
