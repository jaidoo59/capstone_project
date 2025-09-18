# Random ID for unique bucket naming
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# S3 bucket for storing generated audio files
resource "aws_s3_bucket" "audio_bucket" {
  bucket = "text-to-speech-audio-bucket-${random_id.bucket_suffix.hex}"
 
  tags = {
    Name        = "TextToSpeechAudio"
    Environment = "Dev"
  }
}
 
# Disable ACLs, AWS best practice
resource "aws_s3_bucket_ownership_controls" "audio_bucket_ownership" {
  bucket = aws_s3_bucket.audio_bucket.id
 
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Public read access for audio files
resource "aws_s3_bucket_public_access_block" "audio_bucket_pab" {
  bucket = aws_s3_bucket.audio_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "audio_bucket_policy" {
  bucket = aws_s3_bucket.audio_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.audio_bucket_pab]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.audio_bucket.arn}/*"
      }
    ]
  })
}