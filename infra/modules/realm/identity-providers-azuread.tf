resource "keycloak_oidc_identity_provider" "azuread" {
  count = try(var.azuread_identity_provider.enabled, false) ? 1 : 0

  realm        = var.realm_name
  alias        = try(var.azuread_identity_provider.alias, null)
  display_name = try(var.azuread_identity_provider.display_name, null)
  enabled      = try(var.azuread_identity_provider.enabled, null)
  store_token  = true
  trust_email  = true

  authorization_url = try(var.azuread_identity_provider.tenant_id, null) == null ? null : "https://login.microsoftonline.com/${var.azuread_identity_provider.tenant_id}/oauth2/v2.0/authorize"
  token_url         = try(var.azuread_identity_provider.tenant_id, null) == null ? null : "https://login.microsoftonline.com/${var.azuread_identity_provider.tenant_id}/oauth2/v2.0/token"
  jwks_url          = try(var.azuread_identity_provider.tenant_id, null) == null ? null : "https://login.microsoftonline.com/${var.azuread_identity_provider.tenant_id}/discovery/v2.0/keys"
  issuer            = try(var.azuread_identity_provider.tenant_id, null) == null ? null : "https://login.microsoftonline.com/${var.azuread_identity_provider.tenant_id}/v2.0"

  client_id      = try(var.azuread_identity_provider.client_id, null)
  client_secret  = try(var.azuread_identity_provider.client_secret, null)
  default_scopes = try(var.azuread_identity_provider.default_scopes, null)
}
