output "bucket_url" {
  value = aws_s3_bucket.app_bucket.website_endpoint
}
