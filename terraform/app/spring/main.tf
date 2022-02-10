provider "aws" {
  region = var.region
}

data "aws_ami" "spring-ubuntu" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Name"
    values = ["spring-ubuntu"]
  }

  most_recent = true
  owners      = ["self"]
}

resource "aws_instance" "spring" {
  ami                    = data.aws_ami.spring-ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "ec2-keys"
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  vpc_security_group_ids = [aws_security_group.spring.id]

  lifecycle {
    create_before_destroy = true
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ec2/ec2-keys.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "export DB_HOST=${data.terraform_remote_state.db.outputs.db_address}",
      "export DB_PORT=${data.terraform_remote_state.db.outputs.db_port}",
      "nohup java -jar ~/App.jar &",
      "sleep 30", # give the application time to start
    ]
  }
}

resource "aws_security_group" "spring" {
  name   = "spring"
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

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "terraform-state-spring-app"
    key    = "app/mysql/state.tfstate"
    region = var.region
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}
