variable "realm_id" {
  type = string
}

variable "clients" {
  type = any
}

variable "client_ids_by_ref" {
  type = map(string)
}

variable "client_role_ids" {
  type = map(string)
}

variable "service_account_user_ids" {
  type = map(string)
}
