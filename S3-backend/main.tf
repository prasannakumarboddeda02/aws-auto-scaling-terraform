terraform{
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
      }
    }
}

provider "aws" {
  region = "ap-south-1"
}


module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.s3-bucket-unique-name

  force_destroy = true

  versioning = {
    enabled = true
  }
}