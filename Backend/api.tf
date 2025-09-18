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

resource "aws_api_gateway_method" "convert_options" {
  rest_api_id   = aws_api_gateway_rest_api.tts_api.id
  resource_id   = aws_api_gateway_resource.convert_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "convert_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.tts_api.id
  resource_id = aws_api_gateway_resource.convert_resource.id
  http_method = aws_api_gateway_method.convert_options.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "convert_options_response" {
  rest_api_id = aws_api_gateway_rest_api.tts_api.id
  resource_id = aws_api_gateway_resource.convert_resource.id
  http_method = aws_api_gateway_method.convert_options.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "convert_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.tts_api.id
  resource_id = aws_api_gateway_resource.convert_resource.id
  http_method = aws_api_gateway_method.convert_options.http_method
  status_code = aws_api_gateway_method_response.convert_options_response.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "convert_post_response" {
  rest_api_id = aws_api_gateway_rest_api.tts_api.id
  resource_id = aws_api_gateway_resource.convert_resource.id
  http_method = aws_api_gateway_method.convert_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
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
  depends_on = [
    aws_api_gateway_integration.lambda_integration, 
    aws_api_gateway_integration.convert_options_integration,
    aws_api_gateway_integration_response.convert_options_integration_response,
    aws_api_gateway_method_response.convert_post_response
  ]
  
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.convert_resource.id,
      aws_api_gateway_method.convert_method.id,
      aws_api_gateway_method.convert_options.id,
      aws_api_gateway_integration.lambda_integration.id,
      aws_api_gateway_integration.convert_options_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
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