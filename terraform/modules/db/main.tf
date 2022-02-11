provider "aws" {
  region = var.region
}

###################################################
# Create DB instance
###################################################
resource "aws_db_instance" "db" {
  allocated_storage      = "10"
  instance_class         = "db.t2.micro"
  identifier_prefix      = "${var.name}-db-"
  vpc_security_group_ids = [aws_security_group.db.id]

  engine               = var.engine
  engine_version       = var.engine_version
  parameter_group_name = var.parameter_group_name
  db_name              = var.db_name
  db_subnet_group_name = var.subnet_group_name

  publicly_accessible = false
  skip_final_snapshot = true

  username = "root"
  password = "password"
}

resource "aws_security_group" "db" {
  name   = "${var.name}-sg"
  vpc_id = var.vpc_id

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
