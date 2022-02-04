terraform {
  backend "s3" {
    bucket         = "terraform-state-spring-app"
    key            = "state.tfstate"
    dynamodb_table = "terraform-state-spring-app-locks"
    encrypt        = true
  }
}
