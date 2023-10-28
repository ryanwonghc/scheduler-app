terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# budget
resource "aws_budgets_budget" "scheduler-budget" {
  name              = "scheduler-budget"
  budget_type       = "COST"
  limit_amount      = "10"
  limit_unit        = "USD"
  time_period_start = "2023-10-04_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = ["ryanwonghc55@gmail.com"]
  }
}

# dynamoDB table
resource "aws_dynamodb_table" "scheduler-db" {
  name            = "scheduler-db"
  billing_mode    = "PROVISIONED"
  read_capacity   = "20"
  write_capacity  = "20"
  hash_key        = "UserId"
  range_key       = "TaskId"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "TaskId"
    type = "S"
  }

  ttl {
    enabled = true
    attribute_name = "expiryPeriod"
  }

  point_in_time_recovery {
    enabled = true
  }
}

resource "aws_iam_role" "lambda-iam" {
  name = "lambda-iam"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

data "aws_iam_policy" "required-policy" {
  for_each    = toset(var.aws_lambda_iam_roles)
  name        = each.value
}

resource "aws_iam_role_policy_attachment" "lambda-policy" {
  for_each    = data.aws_iam_policy.required-policy

  role        = aws_iam_role.lambda-iam.name
  policy_arn  = each.value.arn
}

resource "aws_iam_role_policy" "dynamodb-lambda-policy" {
  name = "dynamodb-lambda-policy"
  role = aws_iam_role.lambda-iam.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["dynamodb:*"],
        "Resource" : "${aws_dynamodb_table.scheduler-db.arn}"
      }
    ]
  })
}