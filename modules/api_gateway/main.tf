## domain
resource "aws_api_gateway_rest_api" "bookmark_list" {
  name = var.camel_app_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

## deploy
resource "aws_api_gateway_deployment" "bookmark_list" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  depends_on = [
    aws_api_gateway_integration.post_bookmark,
    aws_api_gateway_integration.delete_bookmark_id,
    aws_api_gateway_integration.get_bookmarks,
    aws_api_gateway_integration.post_tag,
    aws_api_gateway_integration.put_tag,
    aws_api_gateway_integration.get_tags,
    aws_api_gateway_integration.ogp_options_mock,
    aws_api_gateway_integration.get_tags_options_mock,
    aws_api_gateway_integration.post_tag_options_mock,
  ]

  triggers = {
    redeployment = sha256(file("modules/api_gateway/main.tf"))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "bookmark_list" {
  deployment_id = aws_api_gateway_deployment.bookmark_list.id
  rest_api_id   = aws_api_gateway_rest_api.bookmark_list.id
  stage_name    = "api"
}

## url
resource "aws_api_gateway_resource" "url" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  parent_id   = aws_api_gateway_rest_api.bookmark_list.root_resource_id
  path_part   = "url"
}

resource "aws_api_gateway_method" "get_ogp" {
  rest_api_id   = aws_api_gateway_rest_api.bookmark_list.id
  resource_id   = aws_api_gateway_resource.url.id
  http_method   = "GET"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "get_ogp" {
  rest_api_id             = aws_api_gateway_rest_api.bookmark_list.id
  resource_id             = aws_api_gateway_resource.url.id
  http_method             = aws_api_gateway_method.get_ogp.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_ogp_lambda_function_invoke_arn
}

resource "aws_api_gateway_method" "ogp_options" {
  rest_api_id   = aws_api_gateway_rest_api.bookmark_list.id
  resource_id   = aws_api_gateway_resource.url.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "ogp_options_200" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  resource_id = aws_api_gateway_resource.url.id
  http_method = aws_api_gateway_method.ogp_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "ogp_options" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  resource_id = aws_api_gateway_resource.url.id
  http_method = aws_api_gateway_method.ogp_options.http_method
  status_code = aws_api_gateway_method_response.ogp_options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_integration" "ogp_options_mock" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  resource_id = aws_api_gateway_resource.url.id
  http_method = aws_api_gateway_method.ogp_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{
  "statusCode": 200
}
EOF
  }
}

## user
resource "aws_api_gateway_resource" "user" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  parent_id   = aws_api_gateway_rest_api.bookmark_list.root_resource_id
  path_part   = "user"
}

resource "aws_api_gateway_resource" "user_name" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  parent_id   = aws_api_gateway_resource.user.id
  path_part   = "{userName}"
}

## bookmark
resource "aws_api_gateway_resource" "bookmark" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  parent_id   = aws_api_gateway_resource.user_name.id
  path_part   = "bookmark"
}

resource "aws_api_gateway_method" "post_bookmark" {
  rest_api_id   = aws_api_gateway_rest_api.bookmark_list.id
  resource_id   = aws_api_gateway_resource.bookmark.id
  http_method   = "POST"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "post_bookmark" {
  rest_api_id             = aws_api_gateway_rest_api.bookmark_list.id
  resource_id             = aws_api_gateway_resource.bookmark.id
  http_method             = aws_api_gateway_method.post_bookmark.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.post_bookmark_lambda_function_invoke_arn
}

resource "aws_api_gateway_method" "post_bookmark_options" {
  rest_api_id   = aws_api_gateway_rest_api.bookmark_list.id
  resource_id   = aws_api_gateway_resource.bookmark.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "post_bookmark_options_200" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  resource_id = aws_api_gateway_resource.bookmark.id
  http_method = aws_api_gateway_method.post_bookmark_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "post_bookmark_options" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  resource_id = aws_api_gateway_resource.bookmark.id
  http_method = aws_api_gateway_method.post_bookmark_options.http_method
  status_code = aws_api_gateway_method_response.post_bookmark_options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_integration" "post_bookmark_options_mock" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  resource_id = aws_api_gateway_resource.bookmark.id
  http_method = aws_api_gateway_method.post_bookmark_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{
  "statusCode": 200
}
EOF
  }
}

resource "aws_api_gateway_resource" "bookmark_id" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  parent_id   = aws_api_gateway_resource.bookmark.id
  path_part   = "{bookmarkID}"
}

resource "aws_api_gateway_method" "delete_bookmark_id" {
  rest_api_id   = aws_api_gateway_rest_api.bookmark_list.id
  resource_id   = aws_api_gateway_resource.bookmark_id.id
  http_method   = "DELETE"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "delete_bookmark_id" {
  rest_api_id             = aws_api_gateway_rest_api.bookmark_list.id
  resource_id             = aws_api_gateway_resource.bookmark_id.id
  http_method             = aws_api_gateway_method.delete_bookmark_id.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.delete_bookmark_id_lambda_function_invoke_arn
}

resource "aws_api_gateway_resource" "bookmarks" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  parent_id   = aws_api_gateway_resource.user_name.id
  path_part   = "bookmarks"
}

resource "aws_api_gateway_method" "get_bookmarks" {
  rest_api_id   = aws_api_gateway_rest_api.bookmark_list.id
  resource_id   = aws_api_gateway_resource.bookmarks.id
  http_method   = "GET"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "get_bookmarks" {
  rest_api_id             = aws_api_gateway_rest_api.bookmark_list.id
  resource_id             = aws_api_gateway_resource.bookmarks.id
  http_method             = aws_api_gateway_method.get_bookmarks.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_bookmarks_lambda_function_invoke_arn
}

resource "aws_api_gateway_method" "get_bookmarks_options" {
  rest_api_id   = aws_api_gateway_rest_api.bookmark_list.id
  resource_id   = aws_api_gateway_resource.bookmarks.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "get_bookmarks_options_200" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  resource_id = aws_api_gateway_resource.bookmarks.id
  http_method = aws_api_gateway_method.get_bookmarks_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "get_bookmarks_options" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  resource_id = aws_api_gateway_resource.bookmarks.id
  http_method = aws_api_gateway_method.get_bookmarks_options.http_method
  status_code = aws_api_gateway_method_response.get_bookmarks_options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_integration" "get_bookmarks_options_mock" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  resource_id = aws_api_gateway_resource.bookmarks.id
  http_method = aws_api_gateway_method.get_bookmarks_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{
  "statusCode": 200
}
EOF
  }
}


## tag
resource "aws_api_gateway_resource" "tag" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  parent_id   = aws_api_gateway_resource.user_name.id
  path_part   = "tag"
}

resource "aws_api_gateway_method" "post_tag" {
  rest_api_id   = aws_api_gateway_rest_api.bookmark_list.id
  resource_id   = aws_api_gateway_resource.tag.id
  http_method   = "POST"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "post_tag" {
  rest_api_id             = aws_api_gateway_rest_api.bookmark_list.id
  resource_id             = aws_api_gateway_resource.tag.id
  http_method             = aws_api_gateway_method.post_tag.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.post_tag_lambda_function_invoke_arn
}

resource "aws_api_gateway_method" "post_tag_options" {
  rest_api_id   = aws_api_gateway_rest_api.bookmark_list.id
  resource_id   = aws_api_gateway_resource.tag.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "post_tag_options_200" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  resource_id = aws_api_gateway_resource.tag.id
  http_method = aws_api_gateway_method.post_tag_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "post_tag_options" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  resource_id = aws_api_gateway_resource.tag.id
  http_method = aws_api_gateway_method.post_tag_options.http_method
  status_code = aws_api_gateway_method_response.post_tag_options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_integration" "post_tag_options_mock" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  resource_id = aws_api_gateway_resource.tag.id
  http_method = aws_api_gateway_method.post_tag_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{
  "statusCode": 200
}
EOF
  }
}

resource "aws_api_gateway_resource" "tag_id" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  parent_id   = aws_api_gateway_resource.tag.id
  path_part   = "{tagID}"
}

resource "aws_api_gateway_method" "put_tag" {
  rest_api_id   = aws_api_gateway_rest_api.bookmark_list.id
  resource_id   = aws_api_gateway_resource.tag_id.id
  http_method   = "PUT"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "put_tag" {
  rest_api_id             = aws_api_gateway_rest_api.bookmark_list.id
  resource_id             = aws_api_gateway_resource.tag_id.id
  http_method             = aws_api_gateway_method.put_tag.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.put_tag_lambda_function_invoke_arn
}

resource "aws_api_gateway_resource" "tags" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  parent_id   = aws_api_gateway_resource.user_name.id
  path_part   = "tags"
}

resource "aws_api_gateway_method" "get_tags" {
  rest_api_id   = aws_api_gateway_rest_api.bookmark_list.id
  resource_id   = aws_api_gateway_resource.tags.id
  http_method   = "GET"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "get_tags" {
  rest_api_id             = aws_api_gateway_rest_api.bookmark_list.id
  resource_id             = aws_api_gateway_resource.tags.id
  http_method             = aws_api_gateway_method.get_tags.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_tags_lambda_function_invoke_arn
}

resource "aws_api_gateway_method" "get_tags_options" {
  rest_api_id   = aws_api_gateway_rest_api.bookmark_list.id
  resource_id   = aws_api_gateway_resource.tags.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "get_tags_options_200" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  resource_id = aws_api_gateway_resource.tags.id
  http_method = aws_api_gateway_method.get_tags_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "get_tags_options" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  resource_id = aws_api_gateway_resource.tags.id
  http_method = aws_api_gateway_method.get_tags_options.http_method
  status_code = aws_api_gateway_method_response.get_tags_options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_integration" "get_tags_options_mock" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  resource_id = aws_api_gateway_resource.tags.id
  http_method = aws_api_gateway_method.get_tags_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{
  "statusCode": 200
}
EOF
  }
}