terraform {
  required_version = ">= 1.5.0"

  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = "~> 5.0"
    }
  }
}

locals {
  keycloak_client_secret = (
    var.keycloak_client_secret != null && trimspace(var.keycloak_client_secret) != ""
  ) ? var.keycloak_client_secret : null

  keycloak_username = (
    var.keycloak_username != null && trimspace(var.keycloak_username) != ""
  ) ? var.keycloak_username : null

  keycloak_password = (
    var.keycloak_password != null && trimspace(var.keycloak_password) != ""
  ) ? var.keycloak_password : null
}

check "keycloak_provider_auth" {
  assert {
    condition = (
      local.keycloak_client_secret != null &&
      local.keycloak_username == null &&
      local.keycloak_password == null
      ) || (
      local.keycloak_client_secret == null &&
      local.keycloak_username != null &&
      local.keycloak_password != null
    )
    error_message = "Configure either keycloak_client_secret for client-credentials auth or both keycloak_username and keycloak_password for password-grant auth."
  }
}

provider "keycloak" {
  url           = var.keycloak_url
  client_id     = var.keycloak_client_id
  client_secret = local.keycloak_client_secret
  username      = local.keycloak_username
  password      = local.keycloak_password
  realm         = var.admin_realm
}
