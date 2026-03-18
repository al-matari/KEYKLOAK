variable "realm_name" {
  type = string
}

variable "realm_id" {
  type = string
}

variable "authentication_flows" {
  type    = any
  default = null
}
