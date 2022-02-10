provider "aws" {
  region = "us-east-2"
}

locals {
  mysql_version = "8.0"
}

resource "aws_db_instance" "db" {
  identifier_prefix      = "db-"
  name                   = "db"
  allocated_storage      = "10"
  instance_class         = "db.t2.micro"
  engine                 = "mysql"
  engine_version         = local.mysql_version
  vpc_security_group_ids = [aws_security_group.db.id]
  parameter_group_name   = aws_db_parameter_group.db.name

  publicly_accessible = true
  skip_final_snapshot = true

  username = "root"
  password = "password"
}

resource "aws_db_parameter_group" "db" {
  name   = "db"
  family = "mysql${local.mysql_version}"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_security_group" "db" {
  name   = "db"
  vpc_id = data.aws_vpc.default.id

  ingress {
    to_port     = 3306
    from_port   = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}
