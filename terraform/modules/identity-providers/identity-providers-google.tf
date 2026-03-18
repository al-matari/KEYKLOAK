resource "keycloak_oidc_identity_provider" "google" {
  count = try(var.google_identity_provider.enabled, false) ? 1 : 0

  realm        = var.realm_name
  alias        = try(var.google_identity_provider.alias, null)
  display_name = try(var.google_identity_provider.display_name, null)
  enabled      = try(var.google_identity_provider.enabled, null)
  store_token  = true
  trust_email  = true

  authorization_url = "https://accounts.google.com/o/oauth2/v2/auth"
  token_url         = "https://oauth2.googleapis.com/token"
  user_info_url     = "https://openidconnect.googleapis.com/v1/userinfo"
  jwks_url          = "https://www.googleapis.com/oauth2/v3/certs"
  issuer            = "https://accounts.google.com"

  client_id      = try(var.google_identity_provider.client_id, null)
  client_secret  = try(var.google_identity_provider.client_secret, null)
  default_scopes = try(var.google_identity_provider.default_scopes, null)
}
