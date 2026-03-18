variable "realm_id" {
  type = string
}

variable "group_ids" {
  type = map(string)
}

variable "users" {
  type      = any
  sensitive = true
}
