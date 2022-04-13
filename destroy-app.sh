#!/bin/zsh
export $(xargs <.env)
APP_DIR=terraform/app

terraform -chdir=$APP_DIR/instance destroy -auto-approve
terraform -chdir=$APP_DIR/db destroy -auto-approve
terraform -chdir=$APP_DIR/vpc destroy -auto-approve
