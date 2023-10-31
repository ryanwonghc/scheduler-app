# API gateway
resource "aws_apigatewayv2_api" "lambda_gateway" {
  name          = "task_scheduler_http_gateway"
  description   = "HTTP Task Scheduler Gateway"
  protocol_type = "HTTP"
}


resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id        = aws_apigatewayv2_api.lambda_gateway.id
  name          = "prod"
  auto_deploy   = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway.arn
    format = jsonencode({
        "requestId" : "$context.requestId",
        "extendedRequestId" : "$context.extendedRequestId",
        "ip" : "$context.identity.sourceIp",
        "caller" : "$context.identity.caller",
        "user" : "$context.identity.user",
        "requestTime" : "$context.requestTime",
        "httpMethod" : "$context.httpMethod",
        "resourcePath" : "$context.resourcePath",
        "status" : "$context.status",
        "protocol" : "$context.protocol",
        "responseLength" : "$context.responseLength",
        "integrationErrorMessage" : "$context.integrationErrorMessage",
        "errorMessage" : "$context.error.message",
        "errorResponseType" : "$context.error.responseType"
    })
  }
}

# POST
resource "aws_apigatewayv2_integration" "task_post_integration" {
  api_id               = aws_apigatewayv2_api.lambda_gateway.id
  integration_type     = "AWS_PROXY"
  integration_method   = "POST"
  integration_uri      = aws_lambda_function.post_task.invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "task_post_route" {
  api_id    = aws_apigatewayv2_api.lambda_gateway.id
  route_key = "POST /task"
  target    = "integrations/${aws_apigatewayv2_integration.task_post_integration.id}"
}

resource "aws_lambda_permission" "task_post_permission" {  
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_task.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_gateway.execution_arn}/*/*/*"
}

# GET
resource "aws_apigatewayv2_integration" "task_get_integration" {
  api_id               = aws_apigatewayv2_api.lambda_gateway.id
  integration_type     = "AWS_PROXY"
  integration_method   = "POST"
  integration_uri      = aws_lambda_function.get_task.invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "task_get_route" {
  api_id    = aws_apigatewayv2_api.lambda_gateway.id
  route_key = "GET /task"
  target    = "integrations/${aws_apigatewayv2_integration.task_get_integration.id}"
}

resource "aws_lambda_permission" "task_get_permission" {  
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_task.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_gateway.execution_arn}/*/*/*"
}