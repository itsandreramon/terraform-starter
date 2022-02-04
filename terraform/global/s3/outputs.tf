output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
}

output "dynamo_db_table" {
  value = aws_dynamodb_table.terraform_locks.name
}
