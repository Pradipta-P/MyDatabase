resource "aws_dynamodb_table" "terraform_dynamodb" {
  name         = "terraform_remote_state"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name        = "dynamodb_table-1"
    Environment = "dev"
  }
}
