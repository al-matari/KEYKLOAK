output "client_ids" {
  value = {
    bearer_only = {
      for name, client in keycloak_openid_client.bearer_only : name => client.id
    }
    confidential = {
      for name, client in keycloak_openid_client.confidential : name => client.id
    }
    public = {
      for name, client in keycloak_openid_client.public : name => client.id
    }
    service_account = {
      for name, client in keycloak_openid_client.service_account : name => client.id
    }
  }
}

output "client_ids_by_ref" {
  value = local.client_ids_by_ref
}

output "service_account_user_ids" {
  value = {
    for name, client in keycloak_openid_client.service_account : name => client.service_account_user_id
  }
}
