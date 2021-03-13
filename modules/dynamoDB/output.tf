output "bookmark_dynamodb_table_name" {
  value = aws_dynamodb_table.bookmark.name
}

output "tag_dynamodb_table_name" {
  value = aws_dynamodb_table.tag.name
}