resource "aws_s3_bucket" "website" {
  bucket = "herodot-infra-company-${lookup(var.workspace_to_stage, terraform.workspace)}-website"
  force_destroy = "false"
}
