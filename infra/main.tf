module "realm" {
  source = "./modules/realm"

  realm_name   = var.realm_name
  display_name = var.display_name

  smtp                      = var.smtp
  themes                    = var.themes
  localization              = var.localization
  security_headers          = var.security_headers
  password_policy           = var.password_policy
  token_settings            = var.token_settings
  session_settings          = var.session_settings
  brute_force               = var.brute_force
  login_settings            = var.login_settings
  otp_policy                = var.otp_policy
  webauthn                  = var.webauthn
  webauthn_passwordless     = var.webauthn_passwordless
  event_settings            = var.event_settings
  realm_attributes          = var.realm_attributes
  components                = var.components
  organizations             = var.organizations
  verifiable_credentials    = var.verifiable_credentials
  default_realm_roles       = var.default_realm_roles
  roles                     = var.roles
  groups                    = var.groups
  users                     = var.users
  ldap_federation           = var.ldap_federation
  google_identity_provider  = var.google_identity_provider
  azuread_identity_provider = var.azuread_identity_provider
  apple_identity_provider   = var.apple_identity_provider
}

module "clients" {
  source = "./modules/clients"

  realm_id = module.realm.realm_id
  clients  = var.clients
}
