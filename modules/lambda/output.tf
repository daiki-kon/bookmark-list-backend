output "post_bookmark_lambda_function_invoke_arn" {
  value = aws_lambda_function.post_bookmark.invoke_arn
}

output "delete_bookmark_id_lambda_function_invoke_arn" {
  value = aws_lambda_function.delete_bookmark_id.invoke_arn
}

output "get_bookmarks_lambda_function_invoke_arn" {
  value = aws_lambda_function.get_bookmarks.invoke_arn
}

output "post_tag_lambda_function_invoke_arn" {
  value = aws_lambda_function.post_tag.invoke_arn
}

output "put_tag_lambda_function_invoke_arn" {
  value = aws_lambda_function.put_tag.invoke_arn
}