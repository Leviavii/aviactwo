variable "vpc_id" {
  type        = string
  description = "VPC to create the security group in"
}

variable "name" {
  type        = string
  default     = "insecure-sg"
  description = "Security group name"
}
