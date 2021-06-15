variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "source_bucket" {
  description = "Bucket where we'll get our lab content from"
  type        = string
  default     = "cl-labs-s3content"
}

variable "source_app_prefix" {
  description = "Directory where we'll get our lab content from"
  type        = string
  default     = "aws-cognito-web-identity-federation/appbucket"
}

variable "source_patches_prefix" {
  description = "Directory where we'll get our lab patches from"
  type        = string
  default     = "aws-cognito-web-identity-federation/patches"
}

variable "destination_bucket" {
  description = "Bucket name where we'll store the content. A unique bucket name will be generated if notthing is provided (see locals)"
  type        = string
  default     = null
}

// The google app client id that you create from following
// https://github.com/acantril/learn-cantrill-io-labs/blob/master/aws-cognito-web-identity-federation/02_LABINSTRUCTIONS/STAGE2%20-%20Create%20Google%20APIProject%20and%20Client%20ID.md
variable "google_client_id" {
  description = "The client-id key you got from registering your google oauth project"
  type        = string
}
