variable "bucket_name" {
  description = "The name of the S3 bucket for the static site"
  type        = string
}

variable "region" {
  description = "The AWS region where the S3 bucket is created"
  type        = string
}