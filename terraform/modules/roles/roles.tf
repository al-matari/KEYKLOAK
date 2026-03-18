resource "keycloak_role" "realm_roles" {
  for_each = var.roles

  realm_id    = var.realm_id
  name        = each.key
  description = try(each.value.description, null)
}
