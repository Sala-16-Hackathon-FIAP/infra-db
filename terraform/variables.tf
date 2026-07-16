variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource tagging"
  type        = string
  default     = "fiapx"
}

variable "db_username" {
  description = "PostgreSQL master username (shared across all RDS instances)"
  type        = string
  default     = "fiapx"
}

variable "db_password" {
  description = "PostgreSQL master password (shared across all RDS instances)"
  type        = string
  sensitive   = true
}
