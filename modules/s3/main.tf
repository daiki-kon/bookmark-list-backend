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


resource "aws_s3_bucket_public_access_block" "markdown" {
  bucket = aws_s3_bucket.markdown.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}