provider "aws" {
  access_key = "<Your Access Key>"
  secret_key = "<Your Secret Key>"
  region = "us-east-1"
}

data "archive_file" "lambda_zip" {
  type = "zip"
  source_file = "greet_lambda.py"
  output_path = var.lambda_result_path
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_func_name}"
  retention_in_days = 5
}

resource "aws_iam_policy" "policy_for_lambda_logs" {
  name        = "policy_for_lambda_logs"
  path        = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.policy_for_lambda_logs.arn
}

resource "aws_lambda_function" "greeting_lambda_func" {
  function_name = var.lambda_func_name
  filename = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler = "greet_lambda.lambda_handler"
  runtime = "python3.8"
  role = aws_iam_role.iam_for_lambda.arn

  environment{
      variables = {
          greeting = "Hello Udacity!"
      }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_logs_policy, aws_cloudwatch_log_group.lambda_log_group]
}
