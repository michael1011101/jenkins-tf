
variable "subaccount_id" {
  description = "Input subaccount GUID"
}

variable "admins" {
  type    = list(string)
  default = []
}


data "btp_subaccount" "subaccount" {
  id = var.subaccount_id
}

resource "btp_subaccount_role_collection_assignment" "name" {
  for_each             = toset(var.admins)
  subaccount           = data.btp_subaccount.subaccount.id
  role_collection_name = "Subaccount Viewer"
  user_name            = each.value
}
