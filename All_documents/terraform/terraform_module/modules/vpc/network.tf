resource "aws_vpc" "terraform_vpc" {
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "${var.tenancy}"

  tags {
    Name = "${var.vpc_name}"   #"tf_vpc"
  }
}

resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "tf_igw"
  }
}

resource "aws_subnet" "private_subnet" {
  count                = "${length(var.availability_zones)}"
  vpc_id               = "${var.vpc_id}"
  availability_zone_id = "${var.availability_zone_ids[count.index]}"
  cidr_block           = "${var.pr_cidr.[count.index]}"

  tags {
    Name = "pr_subnet-${count.index +1}"
  }
}

resource "aws_subnet" "public_subnet" {
  count                = "${length(var.availability_zones)}"
  vpc_id               = "${var.vpc_id}"
  availability_zone_id = "${var.availability_zone_ids[count.index]}"
  cidr_block           = "${var.pub_cidr.[count.index]}"
  map_public_ip_on_launch = "true"
#  availability_zone_id = "use1-az4"

  tags {
    Name = "pb_subnet-${count.index +1}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terraform_igw.id}"
  }

  tags {
    Name = "pb_rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "pr_rt"
  }
}

resource "aws_security_group" "terraform_sg" {
  name        = "${var.security_group}" #"tf_sg"
  description = "${var.sg_description}" #"Security group created through terraform"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "dev_sg"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${var.pub_subnet_ids[count.index]}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${var.pr_subnet_ids[count.index]}"
  route_table_id = "${aws_route_table.private_rt.id}"
}
output "vpc_id" {
  value = "${aws_vpc.terraform_vpc.id}"
}
output "public_subnet_ids" {
  value = ["${aws_subnet.public_subnet.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private_subnet.*.id}"]
}
output "security_group" {
  value = "${aws_security_group.terraform_sg.id}"
}
