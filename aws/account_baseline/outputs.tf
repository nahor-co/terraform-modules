output "accounts" {

    value = tomap({
    for k, account in aws_organizations_account.this : k => account.id
  })
}