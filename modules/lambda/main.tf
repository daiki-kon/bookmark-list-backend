data "archive_file" "post_bookmark" {
  type        = "zip"
  source_dir  = "modules/lambda/src/post_bookmark/"
  output_path = "modules/lambda/src/post_bookmark.zip"
}

resource "aws_lambda_function" "post_bookmark" {
  function_name = "post_bookmark"
  handler       = "main.lambda_handler"
  role          = aws_iam_role.post_bookmark.arn
  runtime       = "python3.8"

  filename         = data.archive_file.post_bookmark.output_path
  source_code_hash = data.archive_file.post_bookmark.output_base64sha256

  timeout     = 10
  memory_size = 256

  tags = {
    App = var.app_name
  }
}

resource "aws_lambda_permission" "post_bookmark" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_bookmark.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_rest_api_bookmark_list_execution_arn}/*/*"
}

data "archive_file" "delete_bookmark_id" {
  type        = "zip"
  source_dir  = "modules/lambda/src/delete_bookmark_id/"
  output_path = "modules/lambda/src/delete_bookmark_id.zip"
}

resource "aws_lambda_function" "delete_bookmark_id" {
  function_name = "delete_bookmark_id"
  handler       = "main.lambda_handler"
  role          = aws_iam_role.delete_bookmark_id.arn
  runtime       = "python3.8"

  filename         = data.archive_file.delete_bookmark_id.output_path
  source_code_hash = data.archive_file.delete_bookmark_id.output_base64sha256

  timeout     = 10
  memory_size = 256

  tags = {
    App = var.app_name
  }
}

resource "aws_lambda_permission" "delete_bookmark_id" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_bookmark_id.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_rest_api_bookmark_list_execution_arn}/*/*"
}