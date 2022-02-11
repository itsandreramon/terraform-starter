provider "aws" {
  region = var.region
}

locals {
  engine  = "mysql"
  version = "8.0"
  port    = 3306
}

module "db" {
  source = "../../modules/db"

  db_name        = "db"
  name           = var.name
  region         = var.region
  port           = local.port
  engine         = local.engine
  engine_version = local.version

  vpc_id               = data.terraform_remote_state.vpc.outputs.id
  subnet_group_name    = data.terraform_remote_state.vpc.outputs.db_subnet_group_name
  parameter_group_name = aws_db_parameter_group.db.name
}

resource "aws_db_parameter_group" "db" {
  name   = "${var.name}-${local.engine}"
  family = "${local.engine}${local.version}"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-state-example"
    key    = "app/vpc/state.tfstate"
    region = var.region
  }
}
