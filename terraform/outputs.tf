output "auth_db_endpoint" {
  description = "auth-service PostgreSQL endpoint"
  value       = aws_db_instance.postgres["auth"].endpoint
}

output "upload_db_endpoint" {
  description = "upload-service PostgreSQL endpoint"
  value       = aws_db_instance.postgres["upload"].endpoint
}

output "processor_db_endpoint" {
  description = "video-processor-service PostgreSQL endpoint"
  value       = aws_db_instance.postgres["processor"].endpoint
}

output "status_db_endpoint" {
  description = "status-service PostgreSQL endpoint"
  value       = aws_db_instance.postgres["status"].endpoint
}

output "notification_db_endpoint" {
  description = "notification-service PostgreSQL endpoint"
  value       = aws_db_instance.postgres["notification"].endpoint
}

output "postgres_port" {
  description = "PostgreSQL port (shared across all instances)"
  value       = 5432
}

output "db_username" {
  description = "PostgreSQL master username"
  value       = var.db_username
}
