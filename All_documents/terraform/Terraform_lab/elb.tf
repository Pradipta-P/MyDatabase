# Create a new load balancer
resource "aws_elb" "web-elb" {
  name            = "web-elb"
  #internal = "true"
  subnets         = ["${aws_subnet.public_subnet.*.id}"] #["${aws_subnet.private_subnet.*.id}"]
  security_groups = ["${aws_security_group.terraform_sg.id}"]
  #instances = ["${aws_instance.terraform_instance.*.id}"]
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
  instances                   = ["${aws_instance.terraform_instance.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 300
  tags = {
    Name = "webserver-elb"
  }
}
