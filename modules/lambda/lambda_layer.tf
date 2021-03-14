data "archive_file" "requests_lambda_layer" {
  type        = "zip"
  source_dir  = "./modules/lambda/lib/requests"
  output_path = "./modules/lambda/requests_lib.zip"
}

resource "aws_lambda_layer_version" "requests" {
  filename            = data.archive_file.requests_lambda_layer.output_path
  layer_name          = "requests"
  compatible_runtimes = ["python3.8"]
  source_code_hash    = data.archive_file.requests_lambda_layer.output_base64sha256
  depends_on          = [data.archive_file.requests_lambda_layer]
}

data "archive_file" "beautifulsoup4_lambda_layer" {
  type        = "zip"
  source_dir  = "./modules/lambda/lib/beautifulsoup4"
  output_path = "./modules/lambda/beautifulsoup4.zip"
}

resource "aws_lambda_layer_version" "beautifulsoup4" {
  filename            = data.archive_file.beautifulsoup4_lambda_layer.output_path
  layer_name          = "beautifulsoup4"
  compatible_runtimes = ["python3.8"]
  source_code_hash    = data.archive_file.beautifulsoup4_lambda_layer.output_base64sha256
  depends_on          = [data.archive_file.beautifulsoup4_lambda_layer]
}