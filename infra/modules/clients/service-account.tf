resource "keycloak_openid_client" "service_account" {
  for_each = local.service_account_clients

  realm_id  = var.realm_id
  client_id = each.value.client_id

  name        = try(each.value.name, null)
  description = try(each.value.description, null)
  enabled     = try(each.value.enabled, null)

  access_type               = "CONFIDENTIAL"
  client_secret             = try(each.value.client_secret, null)
  client_authenticator_type = try(each.value.client_authenticator_type, null)

  standard_flow_enabled                 = false
  implicit_flow_enabled                 = false
  direct_access_grants_enabled          = false
  service_accounts_enabled              = true
  full_scope_allowed                    = try(each.value.full_scope_allowed, null)
  require_dpop_bound_tokens             = try(each.value.require_dpop_bound_tokens, null)
  standard_token_exchange_enabled       = try(each.value.standard_token_exchange_enabled, null)
  use_refresh_tokens_client_credentials = try(each.value.use_refresh_tokens_client_credentials, null)
  extra_config                          = try(each.value.extra_config, null)
}

resource "keycloak_openid_client_default_scopes" "service_account" {
  for_each = local.service_account_clients_with_default_scopes

  realm_id       = var.realm_id
  client_id      = keycloak_openid_client.service_account[each.key].id
  default_scopes = each.value.default_scopes
}

resource "keycloak_openid_client_optional_scopes" "service_account" {
  for_each = local.service_account_clients_with_optional_scopes

  realm_id        = var.realm_id
  client_id       = keycloak_openid_client.service_account[each.key].id
  optional_scopes = each.value.optional_scopes
}
