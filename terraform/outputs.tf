output "realm_id" {
  value = module.realm.realm_id
}

output "realm_name" {
  value = module.realm.realm_name
}

output "client_ids" {
  value = module.clients.client_ids
}

output "service_account_user_ids" {
  value = module.clients.service_account_user_ids
}

output "client_role_ids" {
  value = module.client_roles.client_role_ids
}
