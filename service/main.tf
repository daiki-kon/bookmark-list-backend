module "cognito" {
  source   = "../modules/cognito/"
  app_name = var.app_name
}

module "dynamoDB" {
  source   = "../modules/dynamoDB"
  app_name = var.app_name
}

module "api_gateway" {
  source                                        = "../modules/api_gateway"
  camel_app_name                                = var.camel_app_name
  post_bookmark_lambda_function_invoke_arn      = module.lambda.post_bookmark_lambda_function_invoke_arn
  delete_bookmark_id_lambda_function_invoke_arn = module.lambda.delete_bookmark_id_lambda_function_invoke_arn
  get_bookmarks_lambda_function_invoke_arn      = module.lambda.get_bookmarks_lambda_function_invoke_arn
  post_tag_lambda_function_invoke_arn           = module.lambda.post_tag_lambda_function_invoke_arn
  put_tag_lambda_function_invoke_arn            = module.lambda.put_tag_lambda_function_invoke_arn
  get_tags_lambda_function_invoke_arn           = module.lambda.get_tags_lambda_function_invoke_arn
  get_ogp_lambda_function_invoke_arn            = module.lambda.get_ogp_lambda_function_invoke_arn
}

module "lambda" {
  source                                           = "../modules/lambda"
  app_name                                         = var.app_name
  api_gateway_rest_api_bookmark_list_execution_arn = module.api_gateway.api_gateway_rest_api_bookmark_list_execution_arn
  bookmark_dynamodb_table_name                     = module.dynamoDB.bookmark_dynamodb_table_name
  tag_dynamodb_table_name                          = module.dynamoDB.tag_dynamodb_table_name
}

module "s3" {
  source   = "../modules/s3"
  app_name = var.kebab_app_name
}

module "parameter_store" {
  source                      = "../modules/parameter_store"
  region                      = var.region
  app_name                    = var.camel_app_name
  cognito_identity_pool_id    = module.cognito.cognito_identity_pool_id
  cognito_user_pool_id        = module.cognito.cognito_user_pool_id
  cognito_user_pool_client_id = module.cognito.cognito_user_pool_client_id
  api_gateway_endpoint        = module.api_gateway.bookmark_list_aws_api_gateway_stage_invoke_url
  api_gateway_stage_name      = module.api_gateway.bookmark_list_aws_api_gateway_stage_stage_name
  api_name                    = module.api_gateway.bookmark_list_aws_api_gateway_rest_api_name
  markdown_s3_bucker_name     = module.s3.markdown_aws_s3_bucket_name
}

module "ecr" {
  source = "../modules/ecr"
}

module "iam" {
  source   = "../modules/iam"
  app_name = var.app_name
}