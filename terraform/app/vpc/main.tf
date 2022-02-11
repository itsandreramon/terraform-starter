provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "instance_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}a"
  cidr_block              = "10.0.101.0/24"
  map_public_ip_on_launch = true
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name_prefix = "${var.name}-subnet-group-"

  subnet_ids = [
    aws_subnet.db_subnet_a.id,
    aws_subnet.db_subnet_b.id,
    aws_subnet.db_subnet_c.id,
  ]
}

resource "aws_subnet" "db_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}a"
  cidr_block        = "10.0.1.0/24"
}

resource "aws_subnet" "db_subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}b"
  cidr_block        = "10.0.2.0/24"
}

resource "aws_subnet" "db_subnet_c" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}c"
  cidr_block        = "10.0.3.0/24"
}
