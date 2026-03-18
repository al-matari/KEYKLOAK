resource "keycloak_default_roles" "realm_default_roles" {
  depends_on = [keycloak_role.realm_roles]

  realm_id      = local.realm_id
  default_roles = var.default_realm_roles
}
