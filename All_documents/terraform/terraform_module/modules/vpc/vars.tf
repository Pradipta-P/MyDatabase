variable "vpc_name" {}
variable "vpc_cidr" {}
variable "availability_zones" {
  type = "list"
}
variable "availability_zone_ids" {
  type = "list"
}
variable "pr_cidr" {
  type = "list"
}
variable "pub_cidr" {
  type = "list"
}
variable "vpc_id"{}
variable "pub_subnet_ids" {
  type = "list"
}
variable "pr_subnet_ids" {
  type = "list"
}
variable "tenancy" {
  default = "dedicated"
}
variable "security_group" {}
variable "sg_description" {}
