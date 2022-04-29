module "github_oidc" {

    source = "../."

    github = {
      owner  = "nahor-co"
      repo   = "nahor"
      branch = "main"
    }

    domain = "nahor.ml"
}
