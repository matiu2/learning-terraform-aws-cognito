resource "aws_s3_bucket" "private_bucket" {
  bucket = local.bucket_name

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
  }
}

// Copy from cl-labs-s3content/aws-cognito-web-identity-federation/appbucket to our bucket

data "aws_s3_bucket_objects" "app" {
  bucket = var.source_bucket
  prefix = var.source_app_prefix
}

resource "aws_s3_object_copy" "app" {
  count  = length(data.aws_s3_bucket_objects.app.keys)
  bucket = aws_s3_bucket.private_bucket.bucket
  key    = var.source_app_prefix
  source = "${var.source_bucket}/${data.aws_s3_bucket_objects.app.keys[count.index]}"
}

// Copy from cl-labs-s3content/aws-cognito-web-identity-federation/patches to our bucket

data "aws_s3_bucket_objects" "patches" {
  bucket = var.source_bucket
  prefix = var.source_patches_prefix
}

resource "aws_s3_object_copy" "patches" {
  count  = length(data.aws_s3_bucket_objects.app.keys)
  bucket = aws_s3_bucket.private_bucket.bucket
  key    = var.source_patches_prefix
  source = "${var.source_bucket}/${data.aws_s3_bucket_objects.patches.keys[count.index]}"
}
