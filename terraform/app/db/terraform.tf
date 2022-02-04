terraform {
  backend "s3" {
    key            = "app/db/state.tfstate"
    bucket         = "terraform-state-spring-app"
    dynamodb_table = "terraform-state-spring-app-locks"
    encrypt        = true
  }
}
