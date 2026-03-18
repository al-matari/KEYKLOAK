locals {
  bearer_only_clients     = var.clients.bearer_only
  confidential_clients    = var.clients.confidential
  public_clients          = var.clients.public
  service_account_clients = var.clients.service_account

  confidential_clients_with_default_scopes = {
    for key, client in local.confidential_clients :
    key => client
    if try(client.default_scopes, null) != null
  }

  confidential_clients_with_optional_scopes = {
    for key, client in local.confidential_clients :
    key => client
    if try(client.optional_scopes, null) != null
  }

  public_clients_with_default_scopes = {
    for key, client in local.public_clients :
    key => client
    if try(client.default_scopes, null) != null
  }

  public_clients_with_optional_scopes = {
    for key, client in local.public_clients :
    key => client
    if try(client.optional_scopes, null) != null
  }

  service_account_clients_with_default_scopes = {
    for key, client in local.service_account_clients :
    key => client
    if try(client.default_scopes, null) != null
  }

  service_account_clients_with_optional_scopes = {
    for key, client in local.service_account_clients :
    key => client
    if try(client.optional_scopes, null) != null
  }

  all_clients = merge(
    {
      for key, client in local.bearer_only_clients :
      "bearer_only.${key}" => merge(client, {
        client_type = "bearer_only"
        client_key  = key
      })
    },
    {
      for key, client in local.confidential_clients :
      "confidential.${key}" => merge(client, {
        client_type = "confidential"
        client_key  = key
      })
    },
    {
      for key, client in local.public_clients :
      "public.${key}" => merge(client, {
        client_type = "public"
        client_key  = key
      })
    },
    {
      for key, client in local.service_account_clients :
      "service_account.${key}" => merge(client, {
        client_type = "service_account"
        client_key  = key
      })
    },
  )

  client_ids_by_ref = merge(
    {
      for key, client in keycloak_openid_client.bearer_only :
      "bearer_only.${key}" => client.id
    },
    {
      for key, client in keycloak_openid_client.confidential :
      "confidential.${key}" => client.id
    },
    {
      for key, client in keycloak_openid_client.public :
      "public.${key}" => client.id
    },
    {
      for key, client in keycloak_openid_client.service_account :
      "service_account.${key}" => client.id
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

  protocol_mappers = tomap({
    for item in flatten([
      for client_ref, client in local.all_clients : [
        for mapper_key, mapper in try(client.protocol_mappers, {}) : {
          key = "${client_ref}.${mapper_key}"
          value = {
            client_ref      = client_ref
            mapper_key      = mapper_key
            name            = coalesce(try(mapper.name, null), mapper_key)
            protocol        = try(mapper.protocol, "openid-connect")
            protocol_mapper = mapper.protocol_mapper
            config          = try(mapper.config, {})
          }
        }
      ]
    ]) : item.key => item.value
  })

  realm_role_names = toset(distinct(concat(
    [for mapping in values(local.realm_role_scope_mappings) : mapping.role_name],
    [for mapping in values(local.service_account_realm_role_assignments) : mapping.role_name],
  )))
}
