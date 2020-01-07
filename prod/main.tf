# Specify the provider
provider "aws" {
  region = "us-east-1"
}

#data "terraform_remote_state" "global" {
  #backend = "s3"

  #config = {
    #bucket = "terraform-white-plains-nac-state" 
    #key    = "global/s3/terraform.tfstate"
    #region = "us-east-1"
  #}
#}

#variable "root_domain_name" {
  #default = "mychoir.info"
#}

#variable "prod_domain_name" {
  #default = "prod.mychoir.info"
#}

terraform {
  backend "s3" {
    bucket         = "terraform-white-plains-nac-state"
    key            = "prod/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-white-plains-nac-locks"
    encrypt        = true
  }
}
