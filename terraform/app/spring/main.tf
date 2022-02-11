provider "aws" {
  region = var.region
}

locals {
  key_name = "ec2-keys"
}

module "spring" {
  source = "../../modules/instance"

  type      = "t2.micro"
  name      = var.name
  region    = var.region
  ami       = data.aws_ami.spring-ubuntu.id
  vpc_id    = data.terraform_remote_state.vpc.outputs.id
  subnet_id = data.terraform_remote_state.vpc.outputs.instance_subnet_id
  port_db   = data.terraform_remote_state.mysql.outputs.db_port
  port      = 8080

  username = "ubuntu"
  pem_file = "~/.ec2/${local.key_name}.pem"
  key_name = local.key_name

  exec = [
    "export DB_HOST=${data.terraform_remote_state.mysql.outputs.db_address}",
    "export DB_PORT=${data.terraform_remote_state.mysql.outputs.db_port}",
    "nohup java -jar ~/App.jar &",
    "sleep 30", # give the application time to start
  ]
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

data "terraform_remote_state" "mysql" {
  backend = "s3"

  config = {
    bucket = "terraform-state-sample-1"
    key    = "app/mysql/state.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-state-sample-1"
    key    = "app/vpc/state.tfstate"
    region = var.region
  }
}
