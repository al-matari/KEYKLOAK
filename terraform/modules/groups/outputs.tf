output "group_ids" {
  value = {
    for name, group in keycloak_group.groups : name => group.id
  }
}
