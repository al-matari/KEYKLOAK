resource "keycloak_role" "client_role" {
  for_each = local.client_roles

  realm_id  = var.realm_id
  client_id = local.client_ids_by_ref[each.value.client_ref]

  name        = each.value.name
  description = each.value.description
}
