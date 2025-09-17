# The name of the S3 bucket for frontend hosting
variable "s3_bucket_name" {
  description = "The unique name for the S3 bucket hosting the frontend"
  type        = string
}

# Deployment environment (e.g., Dev, Staging, Prod)
variable "environment" {
  description = "Deployment environment tag"
  type        = string
  default     = "Dev"
}

# CloudFront Origin Access Identity (OAI) IAM ARN
variable "oai_iam_arn" {
  description = "The IAM ARN of the CloudFront Origin Access Identity"
  type        = string
}

# CloudFront Origin Access Identity (OAI) Path
variable "oai_path" {
  description = "The CloudFront OAI path used in the distribution"
  type        = string
}
