provider "aws" {
  region = "us-east-2"
}

resource "aws_db_instance" "db" {
  allocated_storage      = "10"
  instance_class         = "db.t2.micro"
  identifier_prefix      = "${var.name}-db-"
  vpc_security_group_ids = [aws_security_group.db.id]

  engine               = var.engine
  engine_version       = var.engine_version
  db_name              = var.db_name
  parameter_group_name = var.parameter_group

  publicly_accessible = true
  skip_final_snapshot = true

  username = "root"
  password = "password"
}

resource "aws_security_group" "db" {
  name   = "${var.name}-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    to_port     = var.port
    from_port   = var.port
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
