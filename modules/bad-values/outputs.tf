# Each output below IS a hardcoded misconfiguration. The caller consumes these.

output "pitr_enabled" {
  value       = false # DynamoDB-003: point-in-time recovery disabled
  description = "Insecure: DynamoDB PITR disabled"
}

output "ebs_encrypted" {
  value       = false # EBS-003: volume not encrypted
  description = "Insecure: EBS volume encryption disabled"
}

output "multi_az" {
  value       = false # RDS-024: single-AZ
  description = "Insecure: RDS multi-AZ disabled"
}

output "storage_encrypted" {
  value       = false # RDS-024: storage not encrypted
  description = "Insecure: RDS storage encryption disabled"
}

output "deletion_protection" {
  value       = false # RDS-027: cluster deletion protection off
  description = "Insecure: RDS cluster deletion protection disabled"
}

output "tgw_auto_accept" {
  value       = "enable" # Gateway-001: auto-accept shared attachments
  description = "Insecure: Transit Gateway auto-accept enabled"
}

output "api_logging_level" {
  value       = "OFF" # APIGateway-011: execution logging off
  description = "Insecure: API Gateway stage logging off"
}

# S3-013: bucket policy with an allow statement and NO deny for non-TLS traffic.
output "s3_bucket_policy" {
  description = "Insecure: S3 bucket policy missing the deny-HTTP statement"
  value = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowAccountReadNoTLSDeny"
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::${var.account_id}:root" }
      Action    = "s3:GetObject"
      Resource  = "${var.s3_bucket_arn}/*"
    }]
  })
}

# MessagingService-033: event bus policy allowing all principals, no condition.
output "eventbus_policy" {
  description = "Insecure: EventBridge bus policy with Principal '*'"
  value = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowAllPrincipals"
      Effect    = "Allow"
      Principal = "*"
      Action    = "events:PutEvents"
      Resource  = var.eventbus_arn
    }]
  })
}
