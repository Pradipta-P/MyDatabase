resource "aws_route53_zone" "primary" {
  name = "euphoricthoughttech.com"             #"kingyuvi.com"
}

resource "aws_route53_record" "web" {
  zone_id = "${var.dns_zone_id}"
  name    = "${var.route53_record_name}"   #"web.kingyuvi.com"
  type    = "A"

  alias {
    name                   = "${var.elb_dns_name}"
    zone_id                = "${var.elb_zone_id}"
    evaluate_target_health = true
  }
}

output "route53_zone_id" {
  value = "${aws_route53_zone.primary.zone_id}"
}
