resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.10.0.0/16"

  tags {
    Name = "tf_vpc"
  }
}

resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = "${aws_vpc.terraform_vpc.id}"

  tags {
    Name = "tf_igw"
  }
}

resource "aws_subnet" "private_subnet" {
  count                = "${length(var.availability_zones)}"
  vpc_id               = "${aws_vpc.terraform_vpc.id}"
  availability_zone_id = "${var.availability_zone_ids[count.index]}"
  cidr_block           = "${var.pr_cidr.[count.index]}"

  tags {
    Name = "pr_subnet-${count.index +1}"
  }
}

resource "aws_subnet" "public_subnet" {
  count                = "${length(var.availability_zones)}"
  vpc_id               = "${aws_vpc.terraform_vpc.id}"
  availability_zone_id = "${var.availability_zone_ids[count.index]}"
  cidr_block           = "${var.pub_cidr.[count.index]}"
  map_public_ip_on_launch = "true"
#  availability_zone_id = "use1-az4"

  tags {
    Name = "pb_subnet-${count.index +1}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.terraform_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terraform_igw.id}"
  }

  tags {
    Name = "pb_rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = "${aws_vpc.terraform_vpc.id}"

  tags {
    Name = "pr_rt"
  }
}

resource "aws_security_group" "terraform_sg" {
  name        = "tf_sg"
  description = "Security group created through terraform"
  vpc_id      = "${aws_vpc.terraform_vpc.id}"

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
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${aws_subnet.public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${aws_subnet.private_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.private_rt.id}"
}
