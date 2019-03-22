/*terraform {
  backend "s3" {
    bucket = "terraform-rs-bucket"
    key    = "dev/remote-state/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform_remote_state"
  }
}*/


# Note:  remote state does not support interpolation
