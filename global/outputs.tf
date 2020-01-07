output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}

output "kms_key_arn" {
  value = aws_kms_key.parameter_store.arn
  description = "The ARN of the KMS key" 
}

output "route53_zone_main" {
  value = aws_route53_zone.main
  description = "The main Route53 Zone object"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}

