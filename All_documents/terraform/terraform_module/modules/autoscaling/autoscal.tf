
resource "aws_launch_configuration" "l_config" {
  name          = "web_config"
  image_id      = "${lookup(var.aws_ami, var.aws_region)}"
  instance_type = "t2.micro"
  security_groups = ["${var.aws_sg_id}"]
  key_name = "${var.key_name}"
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }
  user_data = "${file("${var.PATH_TO_USER_DATA}")}"
}

resource "aws_autoscaling_group" "as_group" {
  name = "${var.as_group}"
  max_size = 4
  min_size = 1
  desired_capacity = 2
  health_check_grace_period = 300
  health_check_type = "ELB"
  force_delete = true
  launch_configuration = "${var.l_config_name}"
  #availability_zones = ["${var.azs}"]
  vpc_zone_identifier = ["${var.pr_subnet_ids}"]
  load_balancers = ["${var.elb_name}"]

}

resource "aws_autoscaling_policy" "asg_scale_out_policy" {
  name                   = "scale_out_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${var.asg_name}"
}
resource "aws_autoscaling_policy" "asg_scale_in_policy" {
  name                   = "scale_in_policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${var.asg_name}"
}

output "launch_config_name" {
  value = "${aws_launch_configuration.l_config.name}"
}
output "as_group_name" {
  value = "${aws_autoscaling_group.as_group.name}"
}
output "scale_out_policy" {
  value = "${aws_autoscaling_policy.asg_scale_out_policy.arn}"
}
output "scale_in_policy" {
  value = "${aws_autoscaling_policy.asg_scale_in_policy.arn}"
}
