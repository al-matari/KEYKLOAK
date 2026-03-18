resource "keycloak_group" "groups" {
  for_each = var.groups

  realm_id = var.realm_id
  name     = each.key
  attributes = {
    for attribute_key, attribute_values in try(each.value.attributes, {}) :
    attribute_key => attribute_values[0]
    if length(attribute_values) > 0
  }
}

resource "keycloak_group_roles" "group_roles" {
  for_each = local.group_role_assignments

  realm_id = var.realm_id
  group_id = keycloak_group.groups[each.key].id
  role_ids = [
    for role_name in each.value : var.realm_role_ids[role_name]
  ]
}
