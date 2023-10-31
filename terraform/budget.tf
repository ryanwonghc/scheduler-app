# budget
resource "aws_budgets_budget" "scheduler_budget" {
  name              = "scheduler_budget"
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