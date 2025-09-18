resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "${var.s3_bucket_name}-${random_id.frontend_bucket_suffix.hex}"
 
  tags = {
    Name        = "TextToSpeechFrontend"
    Environment = "Dev"
  }
}
 
resource "aws_s3_bucket_public_access_block" "frontend_bucket_pab" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.frontend_bucket.id
 
  index_document {
    suffix = "index.html"
  }
 
  error_document {
    key = "error.html"
  }
}
 
# Bucket policy to allow CloudFront OAI access
resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
  depends_on = [aws_s3_bucket_public_access_block.frontend_bucket_pab]
}
 
# IAM policy document to attach to bucket policy
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.frontend_bucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }
}