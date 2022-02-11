terraform {
  backend "s3" {
    key            = "app/instance/state.tfstate"
    bucket         = "terraform-state-example"
    dynamodb_table = "terraform-state-example-locks"
    encrypt        = true
  }
}
