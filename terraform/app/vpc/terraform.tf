terraform {
  backend "s3" {
    key            = "app/vpc/state.tfstate"
    bucket         = "terraform-state-sample-1"
    dynamodb_table = "terraform-state-sample-1-locks"
    encrypt        = true
  }
}
