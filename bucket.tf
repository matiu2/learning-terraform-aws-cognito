resource "aws_s3_bucket" "private_bucket" {
  bucket = local.bucket_name

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_object_copy" "serverless_app" {
  bucket = aws_s3_bucket.private_bucket
  key    = "destination_key"
  source = "source_bucket/source_key"

  grant {
    uri         = "http://acs.amazonaws.com/groups/global/AllUsers"
    type        = "Group"
    permissions = ["READ"]
  }
}
