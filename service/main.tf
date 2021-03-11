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
}

module "lambda" {
  source                                           = "../modules/lambda"
  app_name                                         = var.app_name
  api_gateway_rest_api_bookmark_list_execution_arn = module.api_gateway.api_gateway_rest_api_bookmark_list_execution_arn
}