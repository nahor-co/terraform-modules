module "instance" {
    source = "../../."

    bucket = "${random_string.random.result}"
}

resource "random_string" "random" {
  length           = 16
}