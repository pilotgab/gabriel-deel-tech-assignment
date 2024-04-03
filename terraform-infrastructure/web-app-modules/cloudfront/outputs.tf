output "s3_bucket_name" {
  description = "The name of the S3 bucket used for the static site"
  value       = aws_s3_bucket.static_site.bucket
}

output "s3_bucket_website_endpoint" {
  description = "The website endpoint URL for the S3 bucket"
  value       = "http://${aws_s3_bucket.static_site.bucket}.s3-website-${var.region}.amazonaws.com"
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.id
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}