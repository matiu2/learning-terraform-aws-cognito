locals {
  // Create a unique bucket name if none is supplied
  bucket_name = var.destination_bucket == null ? "bucket-${uuid()}" : var.destination_bucket
}
