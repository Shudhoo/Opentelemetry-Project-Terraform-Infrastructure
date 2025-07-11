# Outputs for S3 Bucket and DynamoDB
output "s3_bucket_name" {
  value       = aws_s3_bucket.s3_backend.id
  description = "The name of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.dynamodb_locking.id
  description = "The name of the DynamoDB table"
}