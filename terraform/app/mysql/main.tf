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

  db_name         = "db"
  name            = var.name
  port            = local.port
  engine          = local.engine
  engine_version  = local.version
  parameter_group = aws_db_parameter_group.db.name
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
