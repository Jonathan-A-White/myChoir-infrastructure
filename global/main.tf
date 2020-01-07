provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-white-plains-nac-state"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-white-plains-nac-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_kms_key" "parameter_store" {
  description             = "Parameter store kms master key"
  deletion_window_in_days = 10
  enable_key_rotatiion     = true
}

resource "aws_kms_alias" "parameter_store_alias" {
  name          = "alias/parameter_store_key"
  target_key_id = aws_kms_key.parameter_store.id
}

# aws_route53_zone.main:
resource "aws_route53_zone" "main" {
  comment       = "Managed by Terraform"
  force_destroy = false
  name          = "mychoir.info."
  tags = {
    Environment = "prod"
  }
}

# aws_ecr_repository.ecr:
resource "aws_ecr_repository" "ecr" {
  image_tag_mutability = "IMMUTABLE"
  name                 = "mychoir/song-picker"
  tags = {
    Environment = "prod"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  timeouts {}
}

terraform {
  backend "s3" {
    bucket         = "terraform-white-plains-nac-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-white-plains-nac-locks"
    encrypt        = true
  }
}

