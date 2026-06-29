output "s3_bucket_arn" {
  value = aws_s3_bucket.s3_013.arn
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.dynamodb_003.arn
}

output "ebs_volume_id" {
  value = aws_ebs_volume.ebs_003.id
}

output "ebs_snapshot_id" {
  value = aws_ebs_snapshot.snapshot_003.id
}
