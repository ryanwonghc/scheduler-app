variable "aws_region" {
  description = "Default AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

variable "aws_lambda_iam_roles" {
  type        = list(string)
  default     = ["AmazonDynamoDBFullAccess", "CloudWatchFullAccess"]
} 