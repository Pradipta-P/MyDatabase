resource "aws_iam_role" "terraform_s3_role" {
  name = "${var.iam_role}" #"tf_s3"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
     "Principal": {
        "Service": "s3.amazonaws.com",
        "Service": "dynamodb.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
    }
  ]
}
EOF

  tags {
    Name = "test"
  }
}

resource "aws_iam_policy" "policy_s3" {
  name        = "s3_read_write"
  description = "s3 read and write for terraform remote state"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
    "Effect": "Allow",
    "Action":  [
    "s3:GetObject",
    "s3:ListBucket",
    "s3:PutObject"
  ],
    "Resource": "${var.rs_bucket_arn}"
  }
]
}
EOF
}

resource "aws_iam_policy" "policy_dynamodb" {
  name        = "dynamodb_full"
  description = "Dynamodb Read, write and Delete access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
    "Effect": "Allow",
    "Action":  [
    "dynamodb:GetItem",
    "dynamodb:PutItem",
    "dynamodb:DeleteItem"
  ],
    "Resource": "${var.dynamodb_table_arn}"
  }
]
}
EOF
}

resource "aws_iam_user" "user" {
  name = "${var.iam_user}" #"alok"
}

resource "aws_iam_access_key" "key" {
  user = "${var.user}"
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "user_policy_attachment"
  users      = ["${var.user}"]
  policy_arn = "${var.s3_iam_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "s3-attach" {
  role       = "${var.iam_role_s3}"
  policy_arn = "${var.s3_iam_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "dynamodb-attach" {
  role       = "${var.iam_role_s3}"
  policy_arn = "${var.dynamodb_iam_policy_arn}"
}

output "s3_iam_role" {
  value = "${aws_iam_role.terraform_s3_role.name}"
}

output "user_name" {
  value = "${aws_iam_user.user.name}"
}

output "s3_policy_arn" {
  value = "${aws_iam_policy.policy_s3.arn}"
}

output "dynamodb_policy_arn" {
  value = "${aws_iam_policy.policy_dynamodb.arn}"
}
