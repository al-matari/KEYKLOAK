locals {
  user_group_assignments = {
    for username in nonsensitive(keys(var.users)) :
    username => nonsensitive(try(var.users[username].groups, []))
    if length(nonsensitive(try(var.users[username].groups, []))) > 0
  }
}
