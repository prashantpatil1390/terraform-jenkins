provider "aws" {
  region = var.region
}
/*
terraform {
  backend "s3" {
    bucket = "${var.stateBucketName}"
    region = "${var.stateBucketRegion}"
    key    = "${var.stateBucketKey}"
    }
}
*/
