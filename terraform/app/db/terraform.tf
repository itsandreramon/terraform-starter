terraform {
  backend "s3" {
    key            = "app/db/state.tfstate"
    bucket         = "terraform-state-example"
    dynamodb_table = "terraform-state-example-locks"
    encrypt        = true
  }
}
