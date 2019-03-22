resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "terraform_instance" {
  count                  = "${length(var.availability_zones)}"
  ami                    = "${lookup(var.aws_ami, var.aws_region)}"
  availability_zone      = "${var.availability_zones[count.index]}"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.mykey.key_name}"
  subnet_id              = "${aws_subnet.private_subnet.*.id[count.index]}"
  vpc_security_group_ids = ["${aws_security_group.terraform_sg.id}"]
  #user_data              = "${file("script.sh")}"

  tags {
    Name      = "tf_instance"
    AutoStart = "yes"
  }
}
