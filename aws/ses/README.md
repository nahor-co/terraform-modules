# s3

An opinionated Terraform module wrapping `aws_ses_domain_identity` and associated resources

Provides DKIM and SPF configuration, MAIL FROM alginment aids conformance with DMARC policies. 

## Examples

See `./examples`

## Tests

See `./tests`

```
$ aws ses send-email \
  --from "test@<domain>" \
  --destination "ToAddresses=<email_account>@<domain>" \
  --message "Subject={Data=from ses,Charset=utf8},Body={Text={Data=ses says hi,Charset=utf8},Html={Data=,Charset=utf8}}"
```

## Docs

See `./docs`