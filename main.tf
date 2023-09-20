terraform {

  cloud {
    organization = "CallMeSnacktime"

    workspaces {
      name = "terra-house-1"
    }
  }

  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}


provider "aws" {
}

provider "random" {
  # Configuration options
}

resource "random_string" "bucket_name" {
  length           = 25
  special          = false
  lower            = true
  upper            = false
  # https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
}



resource "aws_s3_bucket" "example" {
  # Bucket Naming Rules
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
  bucket = random_string.bucket_name.result
}

output "random_bucket_name_result" {
  value = random_string.bucket_name.result
}