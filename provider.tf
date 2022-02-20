provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "terraform-state-prashant"
    region = "us-east-1"
    key    = "terraform.tfstate"
#    dynamodb_table = "terraform-state-locks"
    encrypt = true
    }
}

