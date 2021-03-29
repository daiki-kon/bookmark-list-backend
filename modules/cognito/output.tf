output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.user_manage.id
}

output "cognito_identity_pool_id" {
  value = aws_cognito_identity_pool.user_manage.id
}

output "cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.user_manage_secret.id
}