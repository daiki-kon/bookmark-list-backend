resource "aws_cloudwatch_log_group" "post_bookmark" {
  name              = "/aws/lambda/${aws_lambda_function.post_bookmark.function_name}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "delete_bookmark_id" {
  name              = "/aws/lambda/${aws_lambda_function.delete_bookmark_id.function_name}"
  retention_in_days = 1
}