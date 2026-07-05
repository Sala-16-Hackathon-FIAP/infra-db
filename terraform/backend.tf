terraform {
  backend "s3" {
    bucket = "fiapx-terraform-state"
    key    = "rds/terraform.tfstate"
    region = "us-east-1"
  }
}
