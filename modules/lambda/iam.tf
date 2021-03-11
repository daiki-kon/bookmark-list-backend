## post_bookmark
resource "aws_iam_role" "post_bookmark_lambda" {
  name = "post_bookmark_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_post_bookmark_lambda_AWSLambdaBasicExecutionRol" {
  role       = aws_iam_role.post_bookmark_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

## delete_bookmark_id
resource "aws_iam_role" "delete_bookmark_id_lambda" {
  name = "delete_bookmark_id_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_delete_bookmark_id_lambda_AWSLambdaBasicExecutionRol" {
  role       = aws_iam_role.delete_bookmark_id_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

## get_bookmarks
resource "aws_iam_role" "get_bookmarks_lambda" {
  name = "get_bookmarks_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_get_bookmarks_lambda_AWSLambdaBasicExecutionRol" {
  role       = aws_iam_role.get_bookmarks_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}