output "realm_scope_mapping_keys" {
  value = keys(local.realm_role_scope_mappings)
}
