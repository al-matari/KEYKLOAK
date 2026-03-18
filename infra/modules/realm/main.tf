locals {
  realm_id = keycloak_realm.this.id

  user_group_assignments = {
    for username in nonsensitive(keys(var.users)) :
    username => nonsensitive(try(var.users[username].groups, []))
    if length(nonsensitive(try(var.users[username].groups, []))) > 0
  }

  group_role_assignments = {
    for group_name, group in var.groups :
    group_name => try(group.realm_roles, [])
    if length(try(group.realm_roles, [])) > 0
  }
}
