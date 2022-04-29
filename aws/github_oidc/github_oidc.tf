data "aws_caller_identity" "current" {}

module "github_oidc" {
  source = "git::https://github.com/DNXLabs/terraform-aws-vcs-oidc.git?ref=0.1.0"

  identity_provider_url = "https://token.actions.githubusercontent.com"
  audiences = [
    "sts.amazonaws.com"
  ]

  roles = [
    {
      name = "githubw"
      assume_roles    = []
      assume_policies = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${local.sync_policy_name}" # avoids tf issue
      ]
      conditions = [
        {
          test     = "ForAllValues:StringEquals"
          variable = "token.actions.githubusercontent.com:sub"
          values   = ["repo:${var.github["owner"]}/${var.github["repo"]}:ref:refs/heads/${var.github["branch"]}"]
        }
      ]
    }
  ]

  depends_on = [aws_iam_policy.this] # avoids tf issue
}

resource "aws_iam_policy" "this" {
  name = local.sync_policy_name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Resource" : [
            "arn:aws:s3:::${var.domain}",
            "arn:aws:s3:::${var.domain}/*"
          ],
          "Sid" : "Stmt1464826210000",
          "Effect" : "Allow",
          "Action" : [
            "s3:DeleteObject",
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:PutObject"
          ]
        }
      ]
  })

}

locals {
  sync_policy_name = "s3_sync"
}
