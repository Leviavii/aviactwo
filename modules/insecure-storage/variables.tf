variable "name_prefix" {
  type        = string
  description = "Prefix for resource names (must be globally unique for the S3 bucket)"
}

variable "availability_zone" {
  type        = string
  description = "AZ for the EBS volume"
}
