output "post_bookmark_lambda_function_invoke_arn" {
  value = aws_lambda_function.post_bookmark.invoke_arn
}

output "delete_bookmark_id_lambda_function_invoke_arn" {
  value = aws_lambda_function.delete_bookmark_id.invoke_arn
}