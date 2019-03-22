resource "aws_dynamodb_table" "terraform_dynamodb" {
  name         = "${var.dynamodb_name}" #"terraform_remote_state"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name        = "dev_table"
    Environment = "dev"
  }
}

output "table_arn" {
  value = "${aws_dynamodb_table.terraform_dynamodb.arn}"
}
