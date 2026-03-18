output "identity_provider_mapper_keys" {
  value = keys(local.identity_provider_mappers)
}

output "ldap_mapper_names" {
  value = try(var.ldap_federation.enabled, false) ? [
    for mapper in coalesce(try(var.ldap_federation.mappers, null), []) : mapper.name
  ] : []
}
