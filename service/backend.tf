terraform {
  backend "s3" {
    bucket = "app-terraform-state-kondo"
    key    = "bookmark-list.tfstate"
    region = "us-east-1"
  }
}