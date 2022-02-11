terraform {
  backend "s3" {
    key            = "app/vpc/state.tfstate"
    bucket         = "terraform-state-example"
    dynamodb_table = "terraform-state-example-locks"
    encrypt        = true
  }
}
