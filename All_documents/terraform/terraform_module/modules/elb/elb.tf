resource "aws_elb" "web-elb" {
  name            = "${var.elb_name}"  #"web-elb"
  #internal = "true"
  subnets         = ["${var.pub_subnet_ids}"] #["${aws_subnet.private_subnet.*.id}"]
  security_groups = ["${var.aws_sg_id}"]
  #instances = ["${var.aws_instance_id}"]
  #availability_zones = ["us-east-1a", "us-east-1b", "us-east-1f"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }
  #instances                   = ["${var.aws_instance_id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 300
  tags = {
    Name = "webserver-elb"
  }
}

output "elb_dns_name" {
  value = "${aws_elb.web-elb.dns_name}"
}

output "elb_zone_id" {
  value = "${aws_elb.web-elb.zone_id}"
}

output "elb_name" {
  value = "${aws_elb.web-elb.name}"
}
