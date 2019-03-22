variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_ami" {
  type = "map"

  default = {
    us-east-1      = "ami-0979e9eaff054dcad"     #"ami-0ac019f4fcb7cb7e6"
    us-east-2      = "ami-0f65671a86f061fcd"
    ap-south-1     = "ami-0d773a3b7bb2bb1c1"
    ap-southeast-1 = "ami-0c5199d385b432989"
  }
}

variable "availability_zones" {
  type    = "list"
  default = ["us-east-1a", "us-east-1b"]
}

variable "availability_zone_ids" {
  type    = "list"
  default = ["use1-az4", "use1-az6"]
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "pr_cidr" {
  type    = "list"
  default = ["10.10.1.0/24", "10.10.2.0/24"]
}
variable "pub_cidr" {
  type    = "list"
  default = ["10.10.3.0/24", "10.10.4.0/24"]
}
