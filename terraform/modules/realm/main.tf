module "realm_settings" {
  source = "../realm-settings"

  realm_name             = var.realm_name
  display_name           = var.display_name
  smtp                   = var.smtp
  themes                 = var.themes
  localization           = var.localization
  security_headers       = var.security_headers
  password_policy        = var.password_policy
  token_settings         = var.token_settings
  session_settings       = var.session_settings
  brute_force            = var.brute_force
  login_settings         = var.login_settings
  otp_policy             = var.otp_policy
  webauthn               = var.webauthn
  webauthn_passwordless  = var.webauthn_passwordless
  event_settings         = var.event_settings
  realm_attributes       = var.realm_attributes
  components             = var.components
  organizations          = var.organizations
  verifiable_credentials = var.verifiable_credentials
}

module "roles" {
  source = "../roles"

  realm_id            = module.realm_settings.realm_id
  default_realm_roles = var.default_realm_roles
  roles               = var.roles
}

module "groups" {
  source = "../groups"

  realm_id       = module.realm_settings.realm_id
  groups         = var.groups
  realm_role_ids = module.roles.realm_role_ids
}

module "users" {
  source = "../users"

  realm_id  = module.realm_settings.realm_id
  users     = var.users
  group_ids = module.groups.group_ids
}

module "identity_providers" {
  source = "../identity-providers"

  realm_name                = var.realm_name
  google_identity_provider  = var.google_identity_provider
  azuread_identity_provider = var.azuread_identity_provider
  apple_identity_provider   = var.apple_identity_provider
}

module "mappers" {
  source = "../mappers"

  realm_name                = var.realm_name
  realm_id                  = module.realm_settings.realm_id
  ldap_federation           = var.ldap_federation
  google_identity_provider  = var.google_identity_provider
  azuread_identity_provider = var.azuread_identity_provider
  apple_identity_provider   = var.apple_identity_provider

  depends_on = [module.identity_providers]
}

module "authentication_flows" {
  source = "../authentication-flows"

  realm_name           = var.realm_name
  realm_id             = module.realm_settings.realm_id
  authentication_flows = null
}
