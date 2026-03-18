data "keycloak_role" "realm_role" {
  for_each = local.realm_role_names

  realm_id = var.realm_id
  name     = each.value
}

resource "keycloak_generic_role_mapper" "realm_scope_mapping" {
  for_each = local.realm_role_scope_mappings

  realm_id  = var.realm_id
  client_id = local.client_ids_by_ref[each.value.client_ref]
  role_id   = data.keycloak_role.realm_role[each.value.role_name].id
}

resource "keycloak_generic_role_mapper" "client_scope_mapping" {
  for_each = local.client_role_scope_mappings

  realm_id  = var.realm_id
  client_id = local.client_ids_by_ref[each.value.client_ref]
  role_id   = keycloak_role.client_role["${each.value.source_client_ref}.${each.value.role_key}"].id
}

resource "keycloak_openid_client_service_account_realm_role" "service_account_realm_role" {
  for_each = local.service_account_realm_role_assignments

  realm_id                = var.realm_id
  service_account_user_id = keycloak_openid_client.service_account[each.value.client_key].service_account_user_id
  role                    = each.value.role_name
}

resource "keycloak_openid_client_service_account_role" "service_account_client_role" {
  for_each = local.service_account_client_role_assignments

  realm_id                = var.realm_id
  service_account_user_id = keycloak_openid_client.service_account[each.value.client_key].service_account_user_id
  client_id               = local.client_ids_by_ref[each.value.source_client_ref]
  role                    = keycloak_role.client_role["${each.value.source_client_ref}.${each.value.role_key}"].name
}
