output "api_gateway_rest_api_bookmark_list_execution_arn" {
  value = aws_api_gateway_rest_api.bookmark_list.execution_arn
}

output "bookmark_list_aws_api_gateway_stage_invoke_url" {
  value = aws_api_gateway_deployment.bookmark_list.invoke_url
}

output "bookmark_list_aws_api_gateway_stage_stage_name" {
  value = aws_api_gateway_stage.bookmark_list.stage_name
}

output "bookmark_list_aws_api_gateway_rest_api_name" {
  value = aws_api_gateway_rest_api.bookmark_list.name
}