data "keycloak_role" "realm_role" {
  for_each = local.realm_role_names

  realm_id = var.realm_id
  name     = each.value
}

resource "keycloak_generic_role_mapper" "realm_scope_mapping" {
  for_each = local.realm_role_scope_mappings

  realm_id  = var.realm_id
  client_id = var.client_ids_by_ref[each.value.client_ref]
  role_id   = data.keycloak_role.realm_role[each.value.role_name].id
}

resource "keycloak_generic_role_mapper" "client_scope_mapping" {
  for_each = local.client_role_scope_mappings

  realm_id  = var.realm_id
  client_id = var.client_ids_by_ref[each.value.client_ref]
  role_id   = var.client_role_ids["${each.value.source_client_ref}.${each.value.role_key}"]
}

resource "keycloak_openid_client_service_account_realm_role" "service_account_realm_role" {
  for_each = local.service_account_realm_role_assignments

  realm_id                = var.realm_id
  service_account_user_id = var.service_account_user_ids[each.value.client_key]
  role                    = each.value.role_name
}

resource "keycloak_openid_client_service_account_role" "service_account_client_role" {
  for_each = local.service_account_client_role_assignments

  realm_id                = var.realm_id
  service_account_user_id = var.service_account_user_ids[each.value.client_key]
  client_id               = var.client_ids_by_ref[each.value.source_client_ref]
  role                    = local.client_role_names["${each.value.source_client_ref}.${each.value.role_key}"]
}
