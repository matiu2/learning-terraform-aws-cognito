// Creates the private S3 bucket that stores the cat pictures
locals {
  private_bucket_name = "${local.bucket_name}-private"
}

resource "aws_s3_bucket" "private_bucket" {
  bucket = local.private_bucket_name
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["http://${aws_s3_bucket.app_bucket.website_endpoint}"]
  }
}

// Copy the patch objects to our bucket

data "aws_s3_bucket_objects" "patches" {
  bucket = var.source_bucket
  prefix = var.source_patches_prefix
}

locals {
  // Remove the prefix from the files, and remove the 'just the prefix' from the list of files
  prefix_files = compact([for key in data.aws_s3_bucket_objects.patches.keys : trimprefix(key, "${data.aws_s3_bucket_objects.patches.prefix}/")])
}

resource "aws_s3_object_copy" "patches" {
  // Add the prefix back again
  for_each = { for postfix in local.prefix_files : "${var.source_bucket}/${data.aws_s3_bucket_objects.patches.prefix}/${postfix}" => postfix }
  bucket   = aws_s3_bucket.private_bucket.bucket
  key      = each.value
  source   = each.key
}
