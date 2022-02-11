#!/bin/zsh
export $(xargs <.env)
APP_DIR=terraform/app

terraform -chdir=$APP_DIR/db init &&
  terraform -chdir=$APP_DIR/db apply -auto-approve

terraform -chdir=$APP_DIR/instance init &&
  terraform -chdir=$APP_DIR/instance apply -auto-approve
