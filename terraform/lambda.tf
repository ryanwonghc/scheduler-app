# POST
data "archive_file" "post_task_zip" {
  source_file   = "../lambdas/post_task.py"
  output_path   = "../lambdas/post_task.zip"
  type          = "zip"
}

resource "aws_lambda_function" "post_task" {
  environment {
    variables = {
      TASK_DB_NAME = aws_dynamodb_table.scheduler_db.name
    }
  }
  memory_size     = "256"
  timeout         = "30"
  runtime         = "python3.9"
  architectures   = ["x86_64"]
  handler         = "post_task.lambda_handler"
  function_name   = "post_task"
  role            = aws_iam_role.lambda_iam.arn
  filename        = "../lambdas/post_task.zip"
  depends_on      = [ aws_iam_role_policy_attachment.lambda-policy ]
  # layers = 
}

# GET
data "archive_file" "get_task_zip" {
  source_file   = "../lambdas/get_task.py"
  output_path   = "../lambdas/get_task.zip"
  type          = "zip"
}

resource "aws_lambda_function" "get_task" {
  environment {
    variables = {
      TASK_DB_NAME = aws_dynamodb_table.scheduler_db.name
    }
  }
  memory_size     = "256"
  timeout         = "30"
  runtime         = "python3.9"
  architectures   = ["x86_64"]
  handler         = "get_task.lambda_handler"
  function_name   = "get_task"
  role            = aws_iam_role.lambda_iam.arn
  filename        = "../lambdas/get_task.zip"
  depends_on      = [ aws_iam_role_policy_attachment.lambda-policy ]
  # layers = 
}



# get post patch delete