
terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~> 1.4.0"
    }
  }
}

provider "btp" {
  globalaccount  = var.global_account_subdomain
  cli_server_url = var.cli_server_url
  username       = var.global_account_username
  password       = var.global_account_password
}

variable "global_account_subdomain" {}
variable "cli_server_url" {
  default = "https://cli.btp.cloud.sap"
}
variable "global_account_username" {}
variable "global_account_password" {
  sensitive = true
}
