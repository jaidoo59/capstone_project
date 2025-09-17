# Output the S3 bucket name
output "frontend_bucket_name" {
  description = "The name of the S3 bucket hosting the frontend"
  value       = aws_s3_bucket.frontend_bucket.bucket
}

# Output the S3 bucket ARN
output "frontend_bucket_arn" {
  description = "The ARN of the S3 bucket hosting the frontend"
  value       = aws_s3_bucket.frontend_bucket.arn
}

# Output the S3 bucket website endpoint (if direct access is needed for testing)
output "frontend_bucket_website_endpoint" {
  description = "The S3 static website endpoint for the frontend bucket"
  value       = aws_s3_bucket_website_configuration.frontend_website.website_endpoint
}
