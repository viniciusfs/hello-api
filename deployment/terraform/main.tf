terraform {
  backend "s3" {
    bucket = "zoop-terraform-tfstates"
    region = "sa-east-1"
    key    = "tmp/hello-api.tfstate"
  }
}

provider "aws" {
  region = var.region
}

data "terraform_remote_state" "cluster" {
  backend = "s3"

  workspace = "${terraform.workspace}"

  config = {
    bucket = "zoop-terraform-tfstates"
    region = "sa-east-1"
    key    = "ecs/playground.tfstate"
  }
}
