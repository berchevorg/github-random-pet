terraform {
  backend "remote" {
    organization = "georgiman"

    workspaces {
      name = "github-random-pet"
    }
  }
}

resource "random_pet" "name" {

  length    = "5"
  separator = "-"
}

output "out" {
  value = "${random_pet.name.id}"
}
