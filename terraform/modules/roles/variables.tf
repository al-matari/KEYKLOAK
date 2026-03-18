variable "realm_id" {
  type = string
}

variable "default_realm_roles" {
  type = list(string)
}

variable "roles" {
  type = any
}
