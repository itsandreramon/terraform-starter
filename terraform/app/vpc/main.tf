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
resource "aws_internet_gateway" "vpc_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.name
  }
}

resource "aws_route_table" "vpc_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_gateway.id
  }
}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.subnet_instance.id
  route_table_id = aws_route_table.vpc_route_table.id
}

###################################################
# Create instance subnet with public ip
###################################################
resource "aws_subnet" "subnet_instance" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}a"
  cidr_block              = "10.0.101.0/24"
  map_public_ip_on_launch = true
}

###################################################
# Create db subnets without public ip
###################################################
resource "aws_db_subnet_group" "subnet_group_db" {
  name_prefix = "${var.name}-db-"

  subnet_ids = [
    aws_subnet.subnet_a_db.id,
    aws_subnet.subnet_b_db.id,
    aws_subnet.subnet_c_db.id,
  ]
}

resource "aws_subnet" "subnet_a_db" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}a"
  cidr_block        = "10.0.1.0/24"
}

resource "aws_subnet" "subnet_b_db" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}b"
  cidr_block        = "10.0.2.0/24"
}

resource "aws_subnet" "subnet_c_db" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}c"
  cidr_block        = "10.0.3.0/24"
}
