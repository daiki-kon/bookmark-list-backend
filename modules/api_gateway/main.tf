## domain
resource "aws_api_gateway_rest_api" "bookmark_list" {
  name = var.camel_app_name
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
  rest_api_id      = aws_api_gateway_rest_api.bookmark_list.id
  resource_id      = aws_api_gateway_resource.bookmark.id
  http_method      = "POST"
  authorization    = "NONE"
}

resource "aws_api_gateway_resource" "bookmark_id" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  parent_id   = aws_api_gateway_resource.bookmark.id
  path_part   = "{bookmarkID}"
}

resource "aws_api_gateway_method" "delete_bookmark_id" {
  rest_api_id      = aws_api_gateway_rest_api.bookmark_list.id
  resource_id      = aws_api_gateway_resource.bookmark_id.id
  http_method      = "DELETE"
  authorization    = "NONE"
}

resource "aws_api_gateway_resource" "bookmarks" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  parent_id   = aws_api_gateway_resource.user_name.id
  path_part   = "bookmarks"
}

resource "aws_api_gateway_method" "get_bookmarks" {
  rest_api_id      = aws_api_gateway_rest_api.bookmark_list.id
  resource_id      = aws_api_gateway_resource.bookmarks.id
  http_method      = "GET"
  authorization    = "NONE"
}

## tag
resource "aws_api_gateway_resource" "tag" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  parent_id   = aws_api_gateway_resource.user_name.id
  path_part   = "tag"
}

resource "aws_api_gateway_method" "post_tag" {
  rest_api_id      = aws_api_gateway_rest_api.bookmark_list.id
  resource_id      = aws_api_gateway_resource.tag.id
  http_method      = "POST"
  authorization    = "NONE"
}

resource "aws_api_gateway_resource" "tag_id" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  parent_id   = aws_api_gateway_resource.tag.id
  path_part   = "{tagID}"
}

resource "aws_api_gateway_method" "put_tag" {
  rest_api_id      = aws_api_gateway_rest_api.bookmark_list.id
  resource_id      = aws_api_gateway_resource.tag_id.id
  http_method      = "PUT"
  authorization    = "NONE"
}

resource "aws_api_gateway_resource" "tags" {
  rest_api_id = aws_api_gateway_rest_api.bookmark_list.id
  parent_id   = aws_api_gateway_resource.user_name.id
  path_part   = "tags"
}

resource "aws_api_gateway_method" "get_tags" {
  rest_api_id      = aws_api_gateway_rest_api.bookmark_list.id
  resource_id      = aws_api_gateway_resource.tags.id
  http_method      = "GET"
  authorization    = "NONE"
}