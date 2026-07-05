resource "aws_security_group" "postgres_sg" {
  name        = "${var.project_name}-postgres-sg"
  description = "Allow PostgreSQL traffic from within the VPC"
  vpc_id      = data.terraform_remote_state.k8s.outputs.vpc_id

  ingress {
    description = "PostgreSQL from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.k8s.outputs.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-postgres-sg" }
}
