# Specify the provider
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-white-plains-nac-state"
    key            = "prod/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-white-plains-nac-locks"
    encrypt        = true
  }
}
