provider "aws" {
  region = "us-east-2"
}

output "db_address" {
  value = aws_db_instance.db.address
}

output "db_port" {
  value = aws_db_instance.db.port
}

output "instance_dns" {
  value = aws_instance.instance.public_dns
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

# EC2 instance
resource "aws_instance" "instance" {
  ami                    = "ami-0b1328d43038f1060"
  instance_type          = "t2.micro"
  key_name               = "myKeys"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data              = <<-EOF
                          #!/bin/bash
                          export DB_HOST=${aws_db_instance.db.address}
                          export DB_PORT=${aws_db_instance.db.port}
                          java -jar ~/App.jar
                          EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance" {
  name = "app-instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
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

# RDS instance
resource "aws_db_instance" "db" {
  identifier_prefix      = "spring-"
  name                   = "db"
  allocated_storage      = "10"
  engine                 = "mysql"
  instance_class         = "db.t2.micro"
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = true
  skip_final_snapshot    = true

  username = "root"
  password = "password"
}

resource "aws_security_group" "db" {
  name = "db-instance"

  ingress {
    from_port   = 3306
    to_port     = 3306
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
