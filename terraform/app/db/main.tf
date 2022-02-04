provider "aws" {
  region = "us-east-2"
}

resource "aws_db_instance" "db" {
  identifier_prefix      = "spring-"
  name                   = "db"
  allocated_storage      = "10"
  engine                 = "mysql"
  instance_class         = "db.t2.micro"
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = true
  skip_final_snapshot = true

  username = "root"
  password = "password"
}

resource "aws_security_group" "rds" {
  name   = "rds"
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
