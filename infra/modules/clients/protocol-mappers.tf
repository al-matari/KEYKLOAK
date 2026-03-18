resource "keycloak_generic_protocol_mapper" "client" {
  for_each = local.protocol_mappers

  realm_id        = var.realm_id
  client_id       = local.client_ids_by_ref[each.value.client_ref]
  name            = each.value.name
  protocol        = each.value.protocol
  protocol_mapper = each.value.protocol_mapper
  config          = each.value.config
}
