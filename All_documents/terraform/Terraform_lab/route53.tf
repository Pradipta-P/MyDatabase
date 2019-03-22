resource "aws_route53_zone" "primary" {
  name = "kingyuvi.com"
}

resource "aws_route53_record" "web" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "web.kingyuvi.com"
  type    = "A"

  alias {
    name                   = "${aws_elb.web-elb.dns_name}"
    zone_id                = "${aws_elb.web-elb.zone_id}"
    evaluate_target_health = true
  }
}
