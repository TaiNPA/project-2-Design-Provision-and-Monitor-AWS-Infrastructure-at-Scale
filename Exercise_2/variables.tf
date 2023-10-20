# TODO: Define the variable for aws_region
variable "aws_region" {
  default = "us-east-1"
}
variable "lambda_func_name" {
  default = "greet_lambda"
}
variable "lambda_result_path" {
  default = "result.zip"
}