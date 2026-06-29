# Cross-repo C2C source-tracing test — STORAGE module.
# Every misconfiguration below is hardcoded HERE (aviactwo). The caller in aviac
# only wires inputs, so Wiz's source tracing should attribute each finding back
# to this file, not to the caller.

data "aws_caller_identity" "current" {}

###############################################################################
# S3-013: S3 Bucket policy should deny HTTP requests
# Misconfig: a bucket policy exists (so Wiz fetches it) but has NO statement
# denying aws:SecureTransport=false. Scoped to the account root (not public)
# to avoid Block-Public-Access apply errors.
###############################################################################
resource "aws_s3_bucket" "s3_013" {
  bucket = "${var.name_prefix}-s3-013"
  tags   = { Project = "wiz-c2c-crossrepo-test" }
}

resource "aws_s3_bucket_policy" "s3_013" {
  bucket = aws_s3_bucket.s3_013.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowAccountReadNoTLSDeny"
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.s3_013.arn}/*"
    }]
  })
}

###############################################################################
# DynamoDB-003: DynamoDB Table point-in-time recovery should be enabled
# Misconfig: point_in_time_recovery disabled.
###############################################################################
resource "aws_dynamodb_table" "dynamodb_003" {
  name         = "${var.name_prefix}-ddb-003"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = false
  }

  tags = { Project = "wiz-c2c-crossrepo-test" }
}

###############################################################################
# EBS-003: EBS Volume should be encrypted
# Misconfig: encrypted = false.
###############################################################################
resource "aws_ebs_volume" "ebs_003" {
  availability_zone = var.availability_zone
  size              = 1
  encrypted         = false
  tags              = { Project = "wiz-c2c-crossrepo-test" }
}

###############################################################################
# Snapshot-003: EBS Volume Snapshot should be encrypted
# Misconfig: snapshot of the unencrypted volume above -> unencrypted snapshot.
###############################################################################
resource "aws_ebs_snapshot" "snapshot_003" {
  volume_id = aws_ebs_volume.ebs_003.id
  tags      = { Project = "wiz-c2c-crossrepo-test" }
}
