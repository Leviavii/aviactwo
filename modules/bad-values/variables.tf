variable "account_id" {
  type        = string
  description = "Account ID used to build the (insecure) S3 bucket policy"
}

variable "s3_bucket_arn" {
  type        = string
  default     = ""
  description = "ARN of the caller's S3 bucket, used to build the insecure policy"
}

variable "eventbus_arn" {
  type        = string
  default     = ""
  description = "ARN of the caller's EventBridge bus, used to build the insecure policy"
}
