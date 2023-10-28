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