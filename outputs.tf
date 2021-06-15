output "bucket_url" {
  value = "http://${aws_s3_bucket.app_bucket.website_endpoint}"
}
