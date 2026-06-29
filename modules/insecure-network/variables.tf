variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
}

variable "db_subnet_group_name" {
  type        = string
  description = "DB subnet group for the RDS instance (created by the caller)"
}
