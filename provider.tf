provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "terraform-state-prash"
    region = "us-east-1"
    key    = "terraform.tfstate"
    encrypt = true
    }
}

