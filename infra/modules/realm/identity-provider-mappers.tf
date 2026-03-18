locals {
  identity_provider_mappers = merge(
    try(var.google_identity_provider.enabled, false) ? {
      for mapper in coalesce(try(var.google_identity_provider.mappers, null), []) :
      "google:${mapper.name}" => merge(mapper, {
        alias = try(var.google_identity_provider.alias, null)
      })
    } : {},
    try(var.azuread_identity_provider.enabled, false) ? {
      for mapper in coalesce(try(var.azuread_identity_provider.mappers, null), []) :
      "azuread:${mapper.name}" => merge(mapper, {
        alias = try(var.azuread_identity_provider.alias, null)
      })
    } : {},
    try(var.apple_identity_provider.enabled, false) ? {
      for mapper in coalesce(try(var.apple_identity_provider.mappers, null), []) :
      "apple:${mapper.name}" => merge(mapper, {
        alias = try(var.apple_identity_provider.alias, null)
      })
    } : {}
  )

  identity_provider_username_templates = merge(
    try(var.google_identity_provider.enabled, false) && try(var.google_identity_provider.username_template, null) != null ? {
      google = merge(var.google_identity_provider.username_template, {
        alias = try(var.google_identity_provider.alias, null)
      })
    } : {},
    try(var.azuread_identity_provider.enabled, false) && try(var.azuread_identity_provider.username_template, null) != null ? {
      azuread = merge(var.azuread_identity_provider.username_template, {
        alias = try(var.azuread_identity_provider.alias, null)
      })
    } : {},
    try(var.apple_identity_provider.enabled, false) && try(var.apple_identity_provider.username_template, null) != null ? {
      apple = merge(var.apple_identity_provider.username_template, {
        alias = try(var.apple_identity_provider.alias, null)
      })
    } : {}
  )
}

resource "keycloak_attribute_importer_identity_provider_mapper" "oidc_mappers" {
  for_each = local.identity_provider_mappers

  realm                   = var.realm_name
  identity_provider_alias = each.value.alias

  name           = each.value.name
  claim_name     = each.value.claim
  user_attribute = each.value.user_attribute

  extra_config = {
    for key, value in {
      syncMode = try(each.value.sync_mode, null)
    } : key => value
    if value != null
  }

  depends_on = [
    keycloak_oidc_identity_provider.google,
    keycloak_oidc_identity_provider.azuread,
    keycloak_oidc_identity_provider.apple,
  ]
}

resource "keycloak_user_template_importer_identity_provider_mapper" "oidc_username_templates" {
  for_each = {
    for provider, config in local.identity_provider_username_templates :
    provider => config
    if try(config.enabled, true) && trimspace(try(config.template, "")) != ""
  }

  realm                   = var.realm_name
  identity_provider_alias = each.value.alias

  name     = "${each.value.alias}-username-template"
  template = each.value.template

  extra_config = {
    for key, value in {
      target   = try(each.value.target, null)
      syncMode = try(each.value.sync_mode, null)
    } : key => value
    if value != null
  }

  depends_on = [
    keycloak_oidc_identity_provider.google,
    keycloak_oidc_identity_provider.azuread,
    keycloak_oidc_identity_provider.apple,
  ]
}
