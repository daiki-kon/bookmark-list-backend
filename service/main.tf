module "cognito" {
  source   = "../modules/cognito/"
  app_name = var.app_name
}

module "dynamoDB" {
  source   = "../modules/dynamoDB"
  app_name = var.app_name
}

module "api_gateway" {
  source = "../modules/api_gateway"
  camel_app_name = var.camel_app_name
}