module "hosted_zone" {

  source = "../."

  domain = "${random_string.random.result}.test"

}

resource "random_string" "random" {
  length = 16
}
