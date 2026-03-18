variable "realm_name" {
  type = string
}

variable "realm_id" {
  type = string
}

variable "ldap_federation" {
  type = any
}

variable "google_identity_provider" {
  type = any
}

variable "azuread_identity_provider" {
  type = any
}

variable "apple_identity_provider" {
  type = any
}
