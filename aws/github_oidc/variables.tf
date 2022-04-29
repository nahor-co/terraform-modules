variable "github" {
  description = "Github source for integration with AWS OIDC identity provider"
  type        = object({
    owner  = string
    repo   = string
    branch = string
  })
}

variable "domain" {
  description = "Domain of website, and so matching s3 bucket name"
  type        = string
}
