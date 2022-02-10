output "s3_bucket_name" {
  value = aws_s3_bucket.state.bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.state.arn
}

output "dynamo_db_table" {
  value = aws_dynamodb_table.locks.name
}
