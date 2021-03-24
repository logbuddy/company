provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${lookup(var.workspace_to_infra_company_aws_account_id, terraform.workspace)}:role/AccountManager"
  }
  region = "us-west-1"
}

provider "aws" {
  alias = "infra_webapp"
  assume_role {
    role_arn = "arn:aws:iam::${lookup(var.workspace_to_infra_webapp_aws_account_id, terraform.workspace)}:role/AccountManager"
  }
  region = "us-west-1"
}
