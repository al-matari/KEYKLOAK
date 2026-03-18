resource "keycloak_user" "users" {
  for_each = nonsensitive(toset(keys(var.users)))

  realm_id       = var.realm_id
  username       = each.key
  email          = var.users[each.key].email
  first_name     = var.users[each.key].first_name
  last_name      = var.users[each.key].last_name
  enabled        = try(var.users[each.key].enabled, true)
  email_verified = try(var.users[each.key].email_verified, true)
  attributes = {
    for attribute_key, attribute_values in try(var.users[each.key].attributes, {}) :
    attribute_key => attribute_values[0]
    if length(attribute_values) > 0
  }
  required_actions = try(var.users[each.key].initial_password.temporary, false) ? ["UPDATE_PASSWORD"] : []

  initial_password {
    value     = var.users[each.key].initial_password.value
    temporary = var.users[each.key].initial_password.temporary
  }
}

resource "keycloak_user_groups" "memberships" {
  for_each = local.user_group_assignments

  realm_id = var.realm_id
  user_id  = keycloak_user.users[each.key].id
  group_ids = [
    for group_name in each.value : var.group_ids[group_name]
  ]
}
