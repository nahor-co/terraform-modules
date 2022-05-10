locals {

}

data "aws_iam_policy_document" "combined_policy_block" {

  #
  # Deny leaving AWS Organizations
  #

  statement {
    sid       = "DenyLeavingOrgs"
    effect    = "Deny"
    actions   = ["organizations:LeaveOrganization"]
    resources = ["*"]
  }

  #
  # Restrict Regional Operations
  #

  statement {
    sid    = "LimitRegions"
    effect = "Deny"

    # These actions do not operate in a specific region, or only run in
    # a single region, so we don't want to try restricting them by region.
    # List of actions can be found in the following example:
    # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_general.html
    not_actions = [
      "a4b:*",
      "access-analyzer:*",
      "acm:*",
      "aws-marketplace-management:*",
      "aws-marketplace:*",
      "aws-portal:*",
      "budgets:*",
      "ce:*",
      "chime:*",
      "cloudfront:*",
      "config:*",
      "cur:*",
      "directconnect:*",
      "ec2:DescribeRegions",
      "ec2:DescribeTransitGateways",
      "ec2:DescribeVpnGateways",
      "fms:*",
      "globalaccelerator:*",
      "health:*",
      "iam:*",
      "importexport:*",
      "kms:*",
      "mobileanalytics:*",
      "networkmanager:*",
      "organizations:*",
      "pricing:*",
      "route53:*",
      "route53domains:*",
      "s3:GetAccountPublic*",
      "s3:ListAllMyBuckets",
      "s3:PutAccountPublic*",
      "shield:*",
      "sts:*",
      "support:*",
      "trustedadvisor:*",
      "waf-regional:*",
      "waf:*",
      "wafv2:*",
      "wellarchitected:*"
    ]

    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values   = var.allowed_regions
    }
  }

  #
  # Require S3 encryption
  #
  # https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingServerSideEncryption.html

  statement {
    sid       = "DenyIncorrectEncryptionHeader"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["*"]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256", "aws:kms"]
    }
  }

  statement {
    sid       = "DenyUnEncryptedObjectUploads"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["*"]
    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = [true]
    }
  }
}

resource "aws_organizations_policy" "this" {
  name        = "combined_scp"
  description = "Opinionated SCP"
  content     = data.aws_iam_policy_document.combined_policy_block.json
}

resource "aws_organizations_policy_attachment" "this" {
  policy_id = aws_organizations_policy.this.id
  target_id = aws_organizations_organizational_unit.this.id
}
