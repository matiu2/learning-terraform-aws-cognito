resource "aws_s3_bucket" "app_bucket" {
  bucket = local.bucket_name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_policy" "read-all" {
  bucket = aws_s3_bucket.app_bucket.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "ReadAll"
    Statement = [
      {
        Sid       = "ReadAll"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:ListBucket", "s3:GetObject"]
        Resource = [
          aws_s3_bucket.app_bucket.arn,
          "${aws_s3_bucket.app_bucket.arn}/*",
        ]
      },
    ]
  })
}

// Copy from cl-labs-s3content/aws-cognito-web-identity-federation/appbucket to our bucket

data "aws_s3_bucket_objects" "app" {
  bucket = var.source_bucket
  prefix = var.source_app_prefix
}

resource "aws_s3_object_copy" "app" {
  count  = length(data.aws_s3_bucket_objects.app.keys)
  bucket = aws_s3_bucket.app_bucket.bucket
  key    = data.aws_s3_bucket_objects.app.keys[count.index]
  source = "${var.source_bucket}/${data.aws_s3_bucket_objects.app.keys[count.index]}"
}

// Copy from cl-labs-s3content/aws-cognito-web-identity-federation/patches to our bucket

data "aws_s3_bucket_objects" "patches" {
  bucket = var.source_bucket
  prefix = var.source_patches_prefix
}

resource "aws_s3_object_copy" "patches" {
  count  = length(data.aws_s3_bucket_objects.app.keys)
  bucket = aws_s3_bucket.app_bucket.bucket
  key    = data.aws_s3_bucket_objects.patches.keys[count.index]
  source = "${var.source_bucket}/${data.aws_s3_bucket_objects.patches.keys[count.index]}"
}
