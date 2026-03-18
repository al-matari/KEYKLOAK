output "user_ids" {
  value = {
    for username, user in keycloak_user.users : username => user.id
  }
}
