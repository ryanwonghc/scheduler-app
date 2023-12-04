resource "aws_cloudwatch_log_group" "api_gateway" {
  name = "/aws/lambda/${aws_apigatewayv2_api.lambda_gateway.name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "api_gateway_post" {
  name = "/aws/lambda/${aws_lambda_function.post_task.function_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "api_gateway_get" {
  name = "/aws/lambda/${aws_lambda_function.get_task.function_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "api_gateway_patch" {
  name = "/aws/lambda/${aws_lambda_function.patch_task.function_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "api_gateway_delete" {
  name = "/aws/lambda/${aws_lambda_function.delete_task.function_name}"
  retention_in_days = 14
}