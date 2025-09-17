# 5. API Gateway (REST API) to trigger the Lambda function
resource "aws_api_gateway_rest_api" "tts_api" {
  name = "TextToSpeechApi"
}

resource "aws_api_gateway_resource" "convert_resource" {
  rest_api_id = aws_api_gateway_rest_api.tts_api.id
  parent_id   = aws_api_gateway_rest_api.tts_api.root_resource_id
  path_part   = "convert"
}

resource "aws_api_gateway_method" "convert_method" {
  rest_api_id   = aws_api_gateway_rest_api.tts_api.id
  resource_id   = aws_api_gateway_resource.convert_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.tts_api.id
  resource_id = aws_api_gateway_resource.convert_resource.id
  http_method = aws_api_gateway_method.convert_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.text_to_speech.invoke_arn
}

resource "aws_api_gateway_deployment" "tts_deployment" {
  rest_api_id = aws_api_gateway_rest_api.tts_api.id
  depends_on = [aws_api_gateway_integration.lambda_integration]
}

resource "aws_api_gateway_stage" "tts_stage" {
  deployment_id = aws_api_gateway_deployment.tts_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.tts_api.id
  stage_name    = "prod"
}

# 6. Give API Gateway permission to invoke the Lambda
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.text_to_speech.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.tts_api.execution_arn}/*/*"
}