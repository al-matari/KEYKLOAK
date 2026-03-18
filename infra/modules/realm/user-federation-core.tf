resource "keycloak_ldap_user_federation" "ldap" {
  count = try(var.ldap_federation.enabled, false) ? 1 : 0

  realm_id = local.realm_id
  name     = try(var.ldap_federation.name, null)
  enabled  = try(var.ldap_federation.enabled, null)

  username_ldap_attribute = try(var.ldap_federation.username_ldap_attribute, null)
  rdn_ldap_attribute      = try(var.ldap_federation.rdn_ldap_attribute, null)
  uuid_ldap_attribute     = try(var.ldap_federation.uuid_ldap_attribute, null)
  user_object_classes     = try(var.ldap_federation.user_object_classes, null)

  connection_url  = try(var.ldap_federation.connection_url, null)
  users_dn        = try(var.ldap_federation.users_dn, null)
  bind_dn         = try(var.ldap_federation.bind_dn, null)
  bind_credential = try(var.ldap_federation.bind_credential, null)

  vendor             = try(upper(var.ldap_federation.vendor), null)
  edit_mode          = try(var.ldap_federation.edit_mode, null)
  import_enabled     = try(var.ldap_federation.import_enabled, null)
  sync_registrations = try(var.ldap_federation.sync_registrations, null)
  trust_email        = try(var.ldap_federation.trust_email, null)
  connection_timeout = try(var.ldap_federation.connection_timeout, null)
  read_timeout       = try(var.ldap_federation.read_timeout, null)
  pagination         = try(var.ldap_federation.pagination, null)
}
