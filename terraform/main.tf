provider "aws" {
  region = "us-east-2"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

# EC2 instance
resource "aws_instance" "instance" {
  ami                    = "ami-0ed33809ce5c950b9"
  instance_type          = "t2.micro"
  key_name               = "myKeys"
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  vpc_security_group_ids = [aws_security_group.ec2.id]
  user_data              = <<EOF
                          #!/bin/bash
                          echo "Hello world" >> ~/test.txt
                          echo "${data.terraform_remote_state.state.outputs.db_address}" >> ~/test.txt
                          echo "${data.terraform_remote_state.state.outputs.db_port}" >> ~/test.txt
                          java -jar ~/App.jar
                          EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ec2" {
  name   = "ec2"
  vpc_id = data.aws_vpc.default.id

  ingress {
    to_port     = 8080
    from_port   = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

# RDS instance
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

# Remote state
data "terraform_remote_state" "state" {
  backend = "s3"

  config = {
    bucket = "terraform-state-spring-app"
    key    = "state.tfstate"
    region = "us-east-2"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-spring-app-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
