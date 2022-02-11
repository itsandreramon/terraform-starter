provider "aws" {
  region = var.region
}

###################################################
# Create VPC and enable DNS
###################################################
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

###################################################
# Allow internet for to VPC via internet gateway
###################################################
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.name
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.instance_subnet.id
  route_table_id = aws_route_table.rt.id
}

###################################################
# Create instance subnet with public ip
###################################################
resource "aws_subnet" "instance_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}a"
  cidr_block              = "10.0.101.0/24"
  map_public_ip_on_launch = true
}

###################################################
# Create db subnets without public ip
###################################################
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
