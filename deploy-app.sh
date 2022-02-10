#!/bin/zsh
export $(xargs <.env)
APP_DIR=terraform/app

terraform -chdir=$APP_DIR/mysql init &&
  terraform -chdir=$APP_DIR/mysql apply -auto-approve

# terraform -chdir=$APP_DIR/spring init &&
#   terraform -chdir=$APP_DIR/spring apply $1 -auto-approve
