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
 
 