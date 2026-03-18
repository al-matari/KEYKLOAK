resource "keycloak_openid_client" "bearer_only" {
  for_each = local.bearer_only_clients

  realm_id  = var.realm_id
  client_id = each.value.client_id

  name        = try(each.value.name, null)
  description = try(each.value.description, null)
  enabled     = try(each.value.enabled, null)

  access_type               = "BEARER-ONLY"
  client_secret             = try(each.value.client_secret, null)
  client_authenticator_type = try(each.value.client_authenticator_type, null)

  standard_flow_enabled        = false
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false
  full_scope_allowed           = try(each.value.full_scope_allowed, null)
  require_dpop_bound_tokens    = try(each.value.require_dpop_bound_tokens, null)
  extra_config                 = try(each.value.extra_config, null)
}
