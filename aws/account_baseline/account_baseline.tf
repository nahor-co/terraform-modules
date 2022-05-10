resource "aws_organizations_organization" "this" {
  feature_set = var.feature_set

  enabled_policy_types = var.enabled_policy_types

}

resource "aws_organizations_organizational_unit" "this" {
  name = var.organizational_unit_name
  parent_id = aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_account" "this" {

  for_each = toset(var.accounts)

  name  = each.key
  email = replace(var.email, "@", "+${each.key}@")
  role_name = var.role_name
  parent_id = aws_organizations_organizational_unit.this.id
  close_on_deletion = var.close_on_deletion
  iam_user_access_to_billing = var.iam_user_access_to_billing

  lifecycle {
    ignore_changes = [role_name, iam_user_access_to_billing]
  }
}
