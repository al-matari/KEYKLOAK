module "clients" {
  source = "./modules/clients"

  realm_id = module.realm.realm_id
  clients  = var.clients
}

module "client_roles" {
  source = "./modules/client-roles"

  realm_id          = module.realm.realm_id
  clients           = var.clients
  client_ids_by_ref = module.clients.client_ids_by_ref
}

module "client_scopes" {
  source = "./modules/client-scopes"

  realm_id                 = module.realm.realm_id
  clients                  = var.clients
  client_ids_by_ref        = module.clients.client_ids_by_ref
  client_role_ids          = module.client_roles.client_role_ids
  service_account_user_ids = module.clients.service_account_user_ids
}
