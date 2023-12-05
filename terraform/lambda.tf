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
  role            = aws_iam_role.lambda_iam.arn
  function_name   = "get_task"
  filename        = "../lambdas/get_task.zip"
  depends_on      = [ aws_iam_role_policy_attachment.lambda-policy ]
  # layers = 
}

# PATCH
data "archive_file" "patch_task_zip" {
  source_file   = "../lambdas/patch_task.py"
  output_path   = "../lambdas/patch_task.zip"
  type          = "zip"
}

resource "aws_lambda_function" "patch_task" {
  environment {
    variables = {
      TASK_DB_NAME = aws_dynamodb_table.scheduler_db.name
    }
  }
  memory_size     = "256"
  timeout         = "30"
  runtime         = "python3.9"
  architectures   = ["x86_64"]
  handler         = "patch_task.lambda_handler"
  function_name   = "patch_task"
  role            = aws_iam_role.lambda_iam.arn
  filename        = "../lambdas/patch_task.zip"
  depends_on      = [ aws_iam_role_policy_attachment.lambda-policy ]
  # layers = 
}

# DELETE
data "archive_file" "delete_task_zip" {
  source_file   = "../lambdas/delete_task.py"
  output_path   = "../lambdas/delete_task.zip"
  type          = "zip"
}

resource "aws_lambda_function" "delete_task" {
  environment {
    variables = {
      TASK_DB_NAME = aws_dynamodb_table.scheduler_db.name
    }
  }
  memory_size     = "256"
  timeout         = "30"
  runtime         = "python3.9"
  architectures   = ["x86_64"]
  handler         = "delete_task.lambda_handler"
  function_name   = "delete_task"
  role            = aws_iam_role.lambda_iam.arn
  filename        = "../lambdas/delete_task.zip"
  depends_on      = [ aws_iam_role_policy_attachment.lambda-policy ]
  # layers = 
}