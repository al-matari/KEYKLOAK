resource "keycloak_oidc_identity_provider" "apple" {
  count = try(var.apple_identity_provider.enabled, false) ? 1 : 0

  realm        = var.realm_name
  alias        = try(var.apple_identity_provider.alias, null)
  display_name = try(var.apple_identity_provider.display_name, null)
  enabled      = try(var.apple_identity_provider.enabled, null)
  store_token  = true
  trust_email  = true

  authorization_url = "https://appleid.apple.com/auth/authorize"
  token_url         = "https://appleid.apple.com/auth/token"
  jwks_url          = "https://appleid.apple.com/auth/keys"
  issuer            = "https://appleid.apple.com"

  client_id      = try(var.apple_identity_provider.client_id, null)
  client_secret  = try(var.apple_identity_provider.client_secret, null)
  default_scopes = try(var.apple_identity_provider.default_scopes, null)
}
