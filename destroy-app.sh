#!/bin/zsh
APP_DIR=terraform/app/
terraform -chdir=$APP_DIR/spring destroy -auto-approve
terraform -chdir=$APP_DIR/db destroy -auto-approve
