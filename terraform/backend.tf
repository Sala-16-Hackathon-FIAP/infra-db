terraform {
  backend "s3" {
    bucket = "fiapx-sala16-v2-terraform-state"
    key    = "rds/terraform.tfstate"
    region = "us-east-1"
  }
}
