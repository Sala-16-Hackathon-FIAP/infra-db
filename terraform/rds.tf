# RDS subnet group — requires 2 subnets in different AZs
resource "aws_db_subnet_group" "default" {
  name = "${var.project_name}-db-subnet-group"
  subnet_ids = [
    data.terraform_remote_state.k8s.outputs.private_subnet_a_id,
    data.terraform_remote_state.k8s.outputs.private_subnet_b_id,
  ]

  tags = { Name = "${var.project_name}-db-subnet-group" }
}

# One PostgreSQL RDS instance per microservice (isolated databases)
locals {
  services = {
    auth         = "fiapx_auth"
    upload       = "fiapx_upload"
    processor    = "fiapx_processor"
    status       = "fiapx_status"
    notification = "fiapx_notification"
  }
}

resource "aws_db_instance" "postgres" {
  for_each = local.services

  identifier             = "${var.project_name}-${each.key}-db"
  allocated_storage      = 20
  db_name                = each.value
  engine                 = "postgres"
  engine_version         = "16.6"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.postgres16"
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  deletion_protection    = false

  tags = {
    Name    = "${var.project_name}-${each.key}-db"
    Service = each.key
  }
}
