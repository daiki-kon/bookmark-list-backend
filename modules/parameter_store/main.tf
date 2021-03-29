resource "aws_ssm_parameter" "cognito_identity_pool_id" {
  name  = "/${var.app_name}/cognitoIdentityPoolId"
  type  = "String"
  value = var.cognito_identity_pool_id
}

resource "aws_ssm_parameter" "cognito_user_pool_id" {
  name  = "/${var.app_name}/cognitoUserPoolId"
  type  = "String"
  value = var.cognito_user_pool_id
}

resource "aws_ssm_parameter" "cognito_user_pool_client_id" {
  name  = "/${var.app_name}/cognitoUserPoolClientId"
  type  = "String"
  value = var.cognito_user_pool_client_id
}

resource "aws_ssm_parameter" "region" {
  name  = "/${var.app_name}/region"
  type  = "String"
  value = var.region
}

resource "aws_ssm_parameter" "api_name" {
  name  = "/${var.app_name}/apiName"
  type  = "String"
  value = var.api_name
}

resource "aws_ssm_parameter" "api_gateway_endpoint" {
  name  = "/${var.app_name}/apiGatewayEndpoint"
  type  = "String"
  value = join("", ["${var.api_gateway_endpoint}", "${var.api_gateway_stage_name}"])
}

resource "aws_ssm_parameter" "markdown_s3_bucker_name" {
  name  = "/${var.app_name}/markdownS3BucketName"
  type  = "String"
  value = var.markdown_s3_bucker_name
}