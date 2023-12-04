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

# Cognito User Pool for authorization
resource "aws_cognito_user_pool" "user_pool" {
  name = "user_pool"
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "task-sched-domain" # needs to be unique
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_user_pool_client" "client" {
  name = "client"
  user_pool_id = aws_cognito_user_pool.user_pool.id
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
  callback_urls                        = ["https://example.com/callback"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]
}

# Authorizer
resource "aws_apigatewayv2_authorizer" "authorizer" {
  name          = "cognito_authorizer"
  api_id        = aws_apigatewayv2_api.lambda_gateway.id
  authorizer_type = "JWT"
  identity_sources = ["$request.header.Authorization"]

  authorizer_result_ttl_in_seconds = 0

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.client.id]
    issuer   = "https://${aws_cognito_user_pool.user_pool.endpoint}"
  }

  # authorizer_uri  = aws_lambda_function.authorizer_lambda.invoke_arn
  # authorizer_payload_format_version = "2.0"
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

  authorizer_id        = aws_apigatewayv2_authorizer.authorizer.id
  authorization_type   = "JWT"
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

  authorizer_id        = aws_apigatewayv2_authorizer.authorizer.id
  authorization_type   = "JWT"
}

resource "aws_lambda_permission" "task_get_permission" {  
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_task.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_gateway.execution_arn}/*/*/*"
}

resource "aws_apigatewayv2_integration" "tasks_get_integration" {
  api_id               = aws_apigatewayv2_api.lambda_gateway.id
  integration_type     = "AWS_PROXY"
  integration_method   = "POST"
  integration_uri      = aws_lambda_function.get_task.invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "tasks_get_route" {
  api_id    = aws_apigatewayv2_api.lambda_gateway.id
  route_key = "GET /tasks"
  target    = "integrations/${aws_apigatewayv2_integration.tasks_get_integration.id}"

  authorizer_id        = aws_apigatewayv2_authorizer.authorizer.id
  authorization_type   = "JWT"
}

resource "aws_lambda_permission" "tasks_get_permission" {  
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_task.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_gateway.execution_arn}/*/*/*"
}

# PATCH
resource "aws_apigatewayv2_integration" "task_patch_integration" {
  api_id               = aws_apigatewayv2_api.lambda_gateway.id
  integration_type     = "AWS_PROXY"
  integration_method   = "POST"
  integration_uri      = aws_lambda_function.patch_task.invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "task_patch_route" {
  api_id    = aws_apigatewayv2_api.lambda_gateway.id
  route_key = "PATCH /task"
  target    = "integrations/${aws_apigatewayv2_integration.task_patch_integration.id}"

  authorizer_id        = aws_apigatewayv2_authorizer.authorizer.id
  authorization_type   = "JWT"
}

resource "aws_lambda_permission" "task_patch_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.patch_task.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_gateway.execution_arn}/*/*/*"
}

# DELETE
resource "aws_apigatewayv2_integration" "task_delete_integration" {
  api_id               = aws_apigatewayv2_api.lambda_gateway.id
  integration_type     = "AWS_PROXY"
  integration_method   = "POST"
  integration_uri      = aws_lambda_function.delete_task.invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "task_delete_route" {
  api_id    = aws_apigatewayv2_api.lambda_gateway.id
  route_key = "DELETE /task"
  target    = "integrations/${aws_apigatewayv2_integration.task_delete_integration.id}"

  authorizer_id        = aws_apigatewayv2_authorizer.authorizer.id
  authorization_type   = "JWT"
}

resource "aws_lambda_permission" "task_delete_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_task.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_gateway.execution_arn}/*/*/*"
}




# api gateway to delete all tasks??