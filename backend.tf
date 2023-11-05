terraform {
  backend "s3" {
    region = "eu-west-1"
    bucket = "iti-terraform"
    key = "demo1/terraform.tfstate"
    dynamodb_table = "elkholy"
  }
}