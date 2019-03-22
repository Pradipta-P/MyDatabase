provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.region}" #"us-east-1"
}

module "my_vpc" {
  source = "../modules/vpc"
  vpc_cidr = "10.10.0.0/16"
  tenancy = "default"
  vpc_name = "dev_vpc"
  vpc_id = "${module.my_vpc.vpc_id}"
  availability_zones = "${var.azs}"
  availability_zone_ids = "${var.azs_id}"
  pr_cidr = "${var.private_cidr}"
  pub_cidr = "${var.public_cidr}"
  pub_subnet_ids = "${module.my_vpc.public_subnet_ids}"
  pr_subnet_ids = "${module.my_vpc.private_subnet_ids}"
  security_group = "dev_sg"
  sg_description = "dev security group allow 80 & 22 from Anywhere"
#  subnet_cidr = "192.168.1.0/24"
}

module "s3" {
  source = "../modules/s3"
  rs_bucket = "terraform-rs-bucket"
  log_bucket = "euphoric-log-bucket"
  availability_zones = "${var.azs}"
  aws_instance_id = "${module.ec2.instance_ids}"
  ebs_volume = "${module.s3.ebs_volume_id}"
}

module "dynamodb" {
  source = "../modules/dynamodb"
  dynamodb_name = "dev_remote_state"
}

module "iam" {
  source = "../modules/iam"
  iam_role = "dev_s3"
  iam_user = "alok"
  rs_bucket_arn = "${module.s3.rs_bucket_arn}"
  log_bucket_arn = "${module.s3.log_bucket_arn}"
  dynamodb_table_arn = "${module.dynamodb.table_arn}"
  user = "${module.iam.user_name}"
  s3_iam_policy_arn = "${module.iam.s3_policy_arn}"
  dynamodb_iam_policy_arn = "${module.iam.dynamodb_policy_arn}"
  iam_role_s3 = "${module.iam.s3_iam_role}"
}

module "key_pair" {
  source = "../modules/key_pair"
}

# ec2 Instance creation

module "ec2" {
  source = "../modules/instance"
  availability_zones = "${var.azs}"
  aws_region = "${var.region}"
  pr_subnet_ids = "${module.my_vpc.private_subnet_ids}"
  aws_sg_id = "${module.my_vpc.security_group}"
  key_name = "${module.key_pair.key_pair_name}"
  PATH_TO_USER_DATA = "${var.script_path}"
}

module "elastic_load_balancer" {
  source = "../modules/elb"
  elb_name = "dev-elb"
  pub_subnet_ids = "${module.my_vpc.public_subnet_ids}"
  aws_sg_id = "${module.my_vpc.security_group}"
  #aws_instance_id = "${module.ec2.instance_ids}"
}

module "route53" {
  source = "../modules/route53"
  dns_zone_id = "${module.route53.route53_zone_id}"
  route53_record_name = "dev.euphoricthoughttech.com"       #"dev.kingyuvi.com"
  elb_dns_name = "${module.elastic_load_balancer.elb_dns_name}"
  elb_zone_id = "${module.elastic_load_balancer.elb_zone_id}"
}

module "autoscale" {
  source = "../modules/autoscaling"
  as_group = "dev-asg"
  aws_region = "${var.region}"
  key_name = "${module.key_pair.key_pair_name}"
  aws_sg_id = "${module.my_vpc.security_group}"
  asg_name = "${module.autoscale.as_group_name}"
  l_config_name = "${module.autoscale.launch_config_name}"
  elb_name = "${module.elastic_load_balancer.elb_name}"
  pr_subnet_ids = "${module.my_vpc.private_subnet_ids}"
  PATH_TO_USER_DATA = "${var.script_path}"
}

module "cloudwatch" {
  source = "../modules/cloudwatch"
  asg_name = "${module.autoscale.as_group_name}"
  scale_out_policy = "${module.autoscale.scale_out_policy}"
  scale_in_policy = "${module.autoscale.scale_in_policy}"
}

output "volume" {
  value = "${module.s3.ebs_volume_id}"
}
