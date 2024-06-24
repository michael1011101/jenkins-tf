
variable "subaccount_id" {
  description = "Input subaccount GUID"
}

variable "admin" {
  type = string
}


data "btp_subaccount" "subaccount" {
  id = var.subaccount_id
}

resource "btp_subaccount_role_collection_assignment" "name" {
  subaccount_id        = data.btp_subaccount.subaccount.id
  role_collection_name = "Subaccount Viewer"
  user_name            = var.admin
}
