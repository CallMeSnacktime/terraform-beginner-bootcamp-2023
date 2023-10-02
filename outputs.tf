output "bucket_name" {
  description = "Bucket name for our static website"
  value = module.terrahouse_aws.bucket_name
}

output "S3_website-endpoint" {

  value = module.terrahouse_aws
}

output "cloudfront_url" {
  description = "The Cloudfront Distribution Domain Name"
  value = module.terrahouse_aws.cloudfront_url
}