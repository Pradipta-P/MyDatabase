resource "aws_iam_role" "terraform_s3_role" {
  name = "tf_s3"

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
    "Resource": "${aws_s3_bucket.terraform_bucket.arn}"
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
    "Resource": "${aws_dynamodb_table.terraform_dynamodb.arn}"
  }
]
}
EOF
}

resource "aws_iam_user" "user" {
  name = "alok"
}

resource "aws_iam_access_key" "key" {
  user = "${aws_iam_user.user.name}"
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "user_policy_attachment"
  users      = ["${aws_iam_user.user.name}"]
  policy_arn = "${aws_iam_policy.policy_s3.arn}"
}

resource "aws_iam_role_policy_attachment" "s3-attach" {
  role       = "${aws_iam_role.terraform_s3_role.name}"
  policy_arn = "${aws_iam_policy.policy_s3.arn}"
}

resource "aws_iam_role_policy_attachment" "dynamodb-attach" {
  role       = "${aws_iam_role.terraform_s3_role.name}"
  policy_arn = "${aws_iam_policy.policy_dynamodb.arn}"
}
