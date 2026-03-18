resource "keycloak_ldap_user_attribute_mapper" "ldap_mappers" {
  for_each = try(var.ldap_federation.enabled, false) ? {
    for mapper in coalesce(try(var.ldap_federation.mappers, null), []) : mapper.name => mapper
  } : {}

  realm_id                = local.realm_id
  ldap_user_federation_id = keycloak_ldap_user_federation.ldap[0].id

  name                        = each.value.name
  user_model_attribute        = each.value.user_model_attribute
  ldap_attribute              = each.value.ldap_attribute
  read_only                   = each.value.read_only
  always_read_value_from_ldap = each.value.always_read_value_from_ldap
}
