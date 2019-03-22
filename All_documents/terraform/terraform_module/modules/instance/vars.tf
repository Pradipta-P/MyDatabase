
variable "availability_zones" {
  type = "list"
}
variable "aws_ami" {
  type = "map"

  default = {
    us-east-1      = "ami-0129d158b07a428f6"     #"ami-0ac019f4fcb7cb7e6"
    us-east-2      = "ami-0f65671a86f061fcd"
    ap-south-1     = "ami-0d773a3b7bb2bb1c1"
    ap-southeast-1 = "ami-0c5199d385b432989"
  }
}
variable "aws_region" {}
variable "pr_subnet_ids" {
  type = "list"
}

variable "aws_sg_id" {}
variable "key_name" {}
variable "PATH_TO_USER_DATA" {}
