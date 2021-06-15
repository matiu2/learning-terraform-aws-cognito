variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "source-bucket-name" {
  description = "Bucket where we'll get our lab content from"
  type        = string
  default     = "cl-labs-s3content"
}

variable "source-bucket-prefix" {
  description = "Directory where we'll get our lab content from"
  type        = string
  default     = "aws-cognito-web-identity-federation/appbucket"
}

variable "destination_bucket" {
  description = "Bucket name where we'll store the content. A unique bucket name will be generated if notthing is provided (see locals)"
  type        = string
  default     = null
}
