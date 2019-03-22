variable "rs_bucket" {}
variable "log_bucket" {}
variable "availability_zones" {
  type = "list"
}
variable "ebs_volume" {
  type = "list"
}

variable "aws_instance_id" {
  type    = "list"
}
