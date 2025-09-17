# 5. API Gateway (HTTP API) to trigger the Lambda function
resource "aws_apigatewayv2_api" "tts_api" {
  name          = "TextToSpeechApi"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "tts_api_stage" {
  api_id      = aws_apigatewayv2_api.tts_api.id
  name        = "prod"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.tts_api.id
  integration_uri    = aws_lambda_function.tts_lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "tts_route" {
  api_id    = aws_apigatewayv2_api.tts_api.id
  route_key = "POST /convert"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# 6. Give API Gateway permission to invoke the Lambda
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tts_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.tts_api.execution_arn}/*/*"
}