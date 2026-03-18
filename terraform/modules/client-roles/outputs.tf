output "client_role_ids" {
  value = {
    for key, role in keycloak_role.client_role : key => role.id
  }
}
