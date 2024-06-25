
variable "subaccount_id" {
  description = "Input subaccount GUID"
}

variable "admins" {
  type = list(string)
}

variable "role_collection_names" {
  type = list(string)
  default = [ "Subaccount Viewer" ]
}

data "btp_subaccount" "subaccount" {
  id = var.subaccount_id
}

resource "btp_subaccount_role_collection_assignment" "name" {
  for_each = {
    for obj in flatten([
      for role_collection in var.role_collection_names: [
        for admin in var.admins: {
          role_collection = role_collection
          user = admin
        }
      ]
    ]): "${obj.role_collection}|${obj.user}" => obj
  }
  subaccount_id        = data.btp_subaccount.subaccount.id
  role_collection_name = each.value.role_collection
  user_name            = each.value.user
}
