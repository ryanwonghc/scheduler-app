# dynamoDB table
resource "aws_dynamodb_table" "scheduler_db" {
  name            = "scheduler_db"
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