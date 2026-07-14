# Reads VPC and subnet IDs from the k8s infrastructure state.
# infra-k8s must be applied first.
data "terraform_remote_state" "k8s" {
  backend = "s3"
  config = {
    bucket = "fiapx-sala16-terraform-state"
    key    = "k8s/terraform.tfstate"
    region = "us-east-1"
  }
}
