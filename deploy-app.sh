#!/bin/zsh
APP_DIR=terraform/app/

terraform -chdir=$APP_DIR/db init &&
  terraform -chdir=$APP_DIR/db apply -auto-approve

terraform -chdir=$APP_DIR/spring init &&
  terraform -chdir=$APP_DIR/spring apply -auto-approve
