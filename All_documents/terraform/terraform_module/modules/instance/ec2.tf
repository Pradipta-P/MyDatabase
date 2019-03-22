

resource "aws_instance" "terraform_instance" {
  count                  = "${length(var.availability_zones)}"
  ami                    = "${lookup(var.aws_ami, var.aws_region)}"
  availability_zone      = "${var.availability_zones[count.index]}"
  instance_type          = "t2.micro"
  key_name               = "${var.key_name}"
  subnet_id              = "${var.pr_subnet_ids[count.index]}"
  vpc_security_group_ids = ["${var.aws_sg_id}"]
  user_data              = "${file("${var.PATH_TO_USER_DATA}")}"

  tags {
    Name      = "web_server"
    AutoStart = "yes"
  }
}

output "instance_ids" {
  value = "${aws_instance.terraform_instance.*.id}"
}
