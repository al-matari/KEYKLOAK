locals {
  group_role_assignments = {
    for group_name, group in var.groups :
    group_name => try(group.realm_roles, [])
    if length(try(group.realm_roles, [])) > 0
  }
}
