module "instance" {
    source = "../../."

    bucket = "${random_string.random.result}"
    acl    = "public-read"
}

resource "random_string" "random" {
  length           = 16
}