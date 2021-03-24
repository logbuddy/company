variable "workspace_to_stage" {
  type = map(string)
  default = {
    default = "prod"
    preprod = "preprod"
  }
}

variable "workspace_to_root_domain" {
  type = map(string)
  default = {
    default = "logbuddy.io"
    preprod = ""
  }
}
