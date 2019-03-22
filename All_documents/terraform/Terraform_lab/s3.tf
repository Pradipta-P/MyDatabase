resource "aws_s3_bucket" "terraform_bucket" {
  bucket = "terraform-rs-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags {
    Name        = "Terraform Remote State"
    Environment = "dev"
  }

  logging {
    target_bucket = "${aws_s3_bucket.log_bucket.id}"
    target_prefix = "tfstate/"
  }
}

# Bucket for logging

resource "aws_s3_bucket" "log_bucket" {
  bucket = "euphoric-log"
  acl    = "log-delivery-write"

  tags {
    Name        = "Logging Bucket"
    Environment = "dev"
  }
}
