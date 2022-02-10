terraform {
  backend "s3" {
    key            = "app/mysql/state.tfstate"
    bucket         = "terraform-state-sample-1"
    dynamodb_table = "terraform-state-sample-1-locks"
    encrypt        = true
  }
}
