# 4. Lambda Function
resource "aws_lambda_function" "tts_lambda" {
  filename      = "lambda_function_payload.zip" # The zipped file containing your code
  function_name = "TextToSpeechFunction"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "main.handler"
  runtime       = "python3.9"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  environment {
    variables = {
      AUDIO_BUCKET_NAME = aws_s3_bucket.audio_bucket.id
    }
  }
}
resource "aws_iam_role" "lambda_role" {
  name = "text_to_speech_lambda_role"
 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}
 
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
 
# S3 full access
resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
 
# Polly full access
resource "aws_iam_role_policy_attachment" "lambda_polly" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonPollyFullAccess"
}