variable "realm_id" {
  type = string
}

variable "clients" {
  type = any
}

variable "client_ids_by_ref" {
  type = map(string)
}
