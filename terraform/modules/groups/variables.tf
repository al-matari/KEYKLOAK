variable "realm_id" {
  type = string
}

variable "groups" {
  type = any
}

variable "realm_role_ids" {
  type = map(string)
}
