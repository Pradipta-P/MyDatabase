resource "aws_ebs_volume" "ebs_volume" {
  count = "${length(var.availability_zones)}"
  availability_zone = "${var.availability_zones[count.index]}"
  size              = 40
  type = "gp2"

  tags = {
    Name = "ebs-${var.availability_zones[count.index]}"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  count = "${length(var.availability_zones)}"
  device_name = "/dev/sdh"
  volume_id   = "${var.ebs_volume[count.index]}"
  instance_id = "${var.aws_instance_id[count.index]}"
}

output "ebs_volume_id" {
  value = "${aws_ebs_volume.ebs_volume.*.id}"
}
