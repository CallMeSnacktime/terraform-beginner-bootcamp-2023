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

tags = {
  UserUuid = var.user_uuid
}

}
