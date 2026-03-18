output "enabled_provider_aliases" {
  value = compact([
    try(var.google_identity_provider.enabled, false) ? try(var.google_identity_provider.alias, "google") : null,
    try(var.azuread_identity_provider.enabled, false) ? try(var.azuread_identity_provider.alias, "azuread") : null,
    try(var.apple_identity_provider.enabled, false) ? try(var.apple_identity_provider.alias, "apple") : null,
  ])
}
