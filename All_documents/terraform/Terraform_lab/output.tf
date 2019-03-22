output ip {
  value = "${aws_instance.terraform_instance.*.public_ip}"
}

output access_key {
  value = "${aws_iam_access_key.key.id}"
}

output secreet_key {
  value = "${aws_iam_access_key.key.secret}"
}

output user {
  value = "${aws_iam_access_key.key.user}"
}

output access_key_status {
  value = "${aws_iam_access_key.key.status}"
}

output elb {
  value = "${aws_elb.web-elb.dns_name}"
}
