output "bucket_url" {
  value = aws_s3_bucket.private_bucket.website_endpoint
}
