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

  realm_role_scope_mappings = tomap({
    for item in flatten([
      for client_ref, client in local.all_clients : [
        for role_name in try(client.scope_mappings.realm_roles, []) : {
          key = "${client_ref}.realm.${role_name}"
          value = {
            client_ref = client_ref
            role_name  = role_name
          }
        }
      ]
    ]) : item.key => item.value
  })

  client_role_scope_mappings = tomap({
    for item in flatten([
      for client_ref, client in local.all_clients : [
        for mapping in try(client.scope_mappings.client_roles, []) : {
          key = "${client_ref}.${mapping.client_type}.${mapping.client_key}.${mapping.role_key}"
          value = {
            client_ref        = client_ref
            source_client_ref = "${mapping.client_type}.${mapping.client_key}"
            role_key          = mapping.role_key
          }
        }
      ]
    ]) : item.key => item.value
  })

  service_account_realm_role_assignments = tomap({
    for item in flatten([
      for client_ref, client in local.all_clients : [
        for role_name in try(client.service_account_roles.realm_roles, []) : {
          key = "${client_ref}.realm.${role_name}"
          value = {
            client_key = client.client_key
            role_name  = role_name
          }
        } if client.client_type == "service_account"
      ]
    ]) : item.key => item.value
  })

  service_account_client_role_assignments = tomap({
    for item in flatten([
      for client_ref, client in local.all_clients : [
        for mapping in try(client.service_account_roles.client_roles, []) : {
          key = "${client_ref}.${mapping.client_type}.${mapping.client_key}.${mapping.role_key}"
          value = {
            client_key        = client.client_key
            source_client_ref = "${mapping.client_type}.${mapping.client_key}"
            role_key          = mapping.role_key
          }
        } if client.client_type == "service_account"
      ]
    ]) : item.key => item.value
  })

  client_role_names = tomap({
    for item in flatten([
      for client_ref, client in local.all_clients : [
        for role_key, role in try(client.roles, {}) : {
          key   = "${client_ref}.${role_key}"
          value = coalesce(try(role.name, null), role_key)
        }
      ]
    ]) : item.key => item.value
  })

  realm_role_names = toset(distinct(concat(
    [for mapping in values(local.realm_role_scope_mappings) : mapping.role_name],
    [for mapping in values(local.service_account_realm_role_assignments) : mapping.role_name],
  )))
}
