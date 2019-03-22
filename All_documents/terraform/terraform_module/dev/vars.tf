variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {
  default = "us-east-1"
}

variable "azs" {
  type = "list"
  default = ["us-east-1a", "us-east-1b"]
}

variable "azs_id" {
  type = "list"
  default = ["use1-az1", "use1-az2"]
}

variable "private_cidr" {
  type = "list"
  default = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "public_cidr" {
  type = "list"
  default = ["10.10.3.0/24", "10.10.4.0/24"]
}
variable "script_path" {
  default = "//home/hp/terraform_modules/script.sh"
}
