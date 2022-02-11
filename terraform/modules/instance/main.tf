provider "aws" {
  region = var.region
}

resource "aws_instance" "instance" {
  ami                         = var.ami
  instance_type               = var.type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.instance.id]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  connection {
    type        = "ssh"
    user        = var.username
    host        = self.public_ip
    private_key = file(var.pem_file)
  }

  provisioner "remote-exec" {
    inline = var.exec
  }
}

resource "aws_security_group" "instance" {
  name   = "${var.name}-sg"
  vpc_id = var.vpc_id

  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    to_port     = var.port
    from_port   = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    to_port     = var.port_db
    from_port   = var.port_db
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


