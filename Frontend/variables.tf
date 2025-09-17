# The name of the S3 bucket for frontend hosting
variable "s3_bucket_name" {
  description = "The unique name for the S3 bucket hosting the frontend"
  type        = string
  default     = "text-to-speech-frontend"
}

# Random ID for unique bucket naming
resource "random_id" "frontend_bucket_suffix" {
  byte_length = 4
}

# Deployment environment (e.g., Dev, Staging, Prod)
variable "environment" {
  description = "Deployment environment tag"
  type        = string
  default     = "Dev"
}


