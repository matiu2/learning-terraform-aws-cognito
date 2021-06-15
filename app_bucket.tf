resource "aws_s3_bucket" "app_bucket" {
  bucket = local.bucket_name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
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

resource "aws_s3_bucket_object" "index_html" {
  bucket = aws_s3_bucket.app_bucket.id
  key = "index.html"
  content = templatefile("index.tpl.html", {google_id = var.google_client_id})
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "scripts" {
  bucket = aws_s3_bucket.app_bucket.id
  key = "scripts.js"
  content = templatefile("scripts.tpl.js", {
    identity_pool_id = aws_cognito_identity_pool.id_pool.id
    private_bucket_name = local.private_bucket_name
    region = var.region
  })
  content_type = "text/javascript"
}
