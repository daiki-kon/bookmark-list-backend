module "cognito" {
  source   = "../modules/cognito/"
  app_name = var.app_name
}

module "dynamoDB" {
  source   = "../modules/dynamoDB"
  app_name = var.app_name
}