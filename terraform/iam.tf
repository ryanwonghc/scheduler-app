# Lambda IAM
resource "aws_iam_role" "lambda_iam" {
  name = "lambda_iam"

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

data "aws_iam_policy" "required_policy" {
  for_each    = toset(var.aws_lambda_iam_roles)
  name        = each.value
}

resource "aws_iam_role_policy_attachment" "lambda-policy" {
  for_each    = data.aws_iam_policy.required_policy

  role        = aws_iam_role.lambda_iam.name
  policy_arn  = each.value.arn
}

resource "aws_iam_role_policy" "dynamodb_lambda_policy" {
  name = "dynamodb_lambda_policy"
  role = aws_iam_role.lambda_iam.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["dynamodb:*"],
        "Resource" : "${aws_dynamodb_table.scheduler_db.arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_logging" {
  name        = "lambda_logging"
  role        = aws_iam_role.lambda_iam.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": ["arn:aws:logs:*:*:*"]
        }
    ]
  })


}