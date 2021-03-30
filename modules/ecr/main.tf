resource "aws_ecr_repository" "amplify_console" {
  name                 = "amplify_console"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}