locals {
  all_clients = merge(
    {
      for key, client in try(var.clients.bearer_only, {}) :
      "bearer_only.${key}" => merge(client, {
        client_type = "bearer_only"
        client_key  = key
      })
    },
    {
      for key, client in try(var.clients.confidential, {}) :
      "confidential.${key}" => merge(client, {
        client_type = "confidential"
        client_key  = key
      })
    },
    {
      for key, client in try(var.clients.public, {}) :
      "public.${key}" => merge(client, {
        client_type = "public"
        client_key  = key
      })
    },
    {
      for key, client in try(var.clients.service_account, {}) :
      "service_account.${key}" => merge(client, {
        client_type = "service_account"
        client_key  = key
      })
    },
  )

  client_roles = tomap({
    for item in flatten([
      for client_ref, client in local.all_clients : [
        for role_key, role in try(client.roles, {}) : {
          key = "${client_ref}.${role_key}"
          value = {
            client_ref  = client_ref
            role_key    = role_key
            name        = coalesce(try(role.name, null), role_key)
            description = try(role.description, null)
          }
        }
      ]
    ]) : item.key => item.value
  })
}
