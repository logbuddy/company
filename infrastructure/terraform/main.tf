provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::829748688443:role/AccountManager"
  }
  region = "us-west-1"
}
