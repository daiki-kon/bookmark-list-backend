resource "aws_iam_role" "amplify_console" {
  name = "bookmark-list.amplify-console"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "amplify.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    App = var.app_name
  }
}

resource "aws_iam_role_policy_attachment" "amplify_console_attach_admin" {
  role       = aws_iam_role.amplify_console.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
