resource "aws_dynamodb_table" "tag" {
  name           = "${var.app_name}_tag"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "userName"
  range_key      = "tagID"

  attribute {
    name = "userName"
    type = "S"
  }

  attribute {
    name = "tagID"
    type = "S"
  }

  tags = {
    Name = "${var.app_name}_tag"
    App  = var.app_name
  }
}

resource "aws_dynamodb_table" "bookmark" {
  name           = "${var.app_name}_bookmark"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "userName"
  range_key      = "bookmarkID"

  attribute {
    name = "userName"
    type = "S"
  }

  attribute {
    name = "bookmarkID"
    type = "S"
  }

  tags = {
    Name = "${var.app_name}_bookmark"
    App  = var.app_name
  }
}