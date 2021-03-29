resource "aws_s3_bucket" "markdown" {
  bucket = "${var.app_name}-markdown"
  acl    = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT"]
    allowed_origins = ["*"]
  }

  tags = {
    Name = "${var.app_name}_tag"
    App  = var.app_name
  }
}

