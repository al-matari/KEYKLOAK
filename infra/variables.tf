variable "keycloak_url" {
  type        = string
  description = "Base URL of Keycloak, e.g. https://sso.example.com"
}

variable "admin_realm" {
  type        = string
  description = "Admin realm used by Terraform provider"
  default     = "master"
}

variable "keycloak_client_id" {
  type        = string
  description = "Admin client ID used for Terraform authentication"
  default     = "admin-cli"
}

variable "keycloak_client_secret" {
  type        = string
  description = "Admin client secret for client-credentials auth"
  sensitive   = true
  default     = null
  nullable    = true
}

variable "keycloak_username" {
  type        = string
  description = "Admin username for password-grant auth"
  default     = null
  nullable    = true
}

variable "keycloak_password" {
  type        = string
  description = "Admin password for password-grant auth"
  sensitive   = true
  default     = null
  nullable    = true
}

variable "realm_name" {
  type = string
}

variable "display_name" {
  type     = string
  default  = null
  nullable = true
}

variable "smtp" {
  type = object({
    host                  = optional(string)
    port                  = optional(number)
    from                  = optional(string)
    from_display_name     = optional(string)
    reply_to              = optional(string)
    reply_to_display_name = optional(string)
    envelope_from         = optional(string)
    ssl                   = optional(bool)
    starttls              = optional(bool)
    auth_username         = optional(string)
    auth_password         = optional(string)
  })
  default  = null
  nullable = true
}

variable "themes" {
  type = object({
    login_theme   = optional(string)
    account_theme = optional(string)
    admin_theme   = optional(string)
    email_theme   = optional(string)
  })
  default  = null
  nullable = true
}

variable "localization" {
  type = object({
    supported_locales = optional(list(string))
    default_locale    = optional(string)
  })
  default  = null
  nullable = true
}

variable "security_headers" {
  type = object({
    x_frame_options           = optional(string)
    content_security_policy   = optional(string)
    x_content_type_options    = optional(string)
    x_xss_protection          = optional(string)
    strict_transport_security = optional(string)
    referrer_policy           = optional(string)
  })
  default  = null
  nullable = true
}

variable "password_policy" {
  type     = string
  default  = null
  nullable = true
}

variable "token_settings" {
  type = object({
    access_code_lifespan_login               = optional(string)
    access_token_lifespan                    = optional(string)
    access_token_lifespan_for_implicit_flow  = optional(string)
    action_token_generated_by_admin_lifespan = optional(string)
    action_token_generated_by_user_lifespan  = optional(string)
  })
  default  = null
  nullable = true
}

variable "session_settings" {
  type = object({
    sso_session_idle_timeout             = optional(string)
    sso_session_max_lifespan             = optional(string)
    sso_session_idle_timeout_remember_me = optional(string)
    sso_session_max_lifespan_remember_me = optional(string)
    client_session_idle_timeout          = optional(string)
    client_session_max_lifespan          = optional(string)
    offline_session_idle_timeout         = optional(string)
    offline_session_max_lifespan_enabled = optional(bool)
    offline_session_max_lifespan         = optional(string)
  })
  default  = null
  nullable = true
}

variable "brute_force" {
  type = object({
    permanent_lockout                = optional(bool)
    max_login_failures               = optional(number)
    wait_increment_seconds           = optional(number)
    quick_login_check_milli_seconds  = optional(number)
    minimum_quick_login_wait_seconds = optional(number)
    max_failure_wait_seconds         = optional(number)
    failure_reset_time_seconds       = optional(number)
  })
  default  = null
  nullable = true
}

variable "login_settings" {
  type = object({
    registration_allowed           = optional(bool)
    registration_email_as_username = optional(bool)
    remember_me                    = optional(bool)
    verify_email                   = optional(bool)
    login_with_email_allowed       = optional(bool)
    duplicate_emails_allowed       = optional(bool)
    reset_password_allowed         = optional(bool)
    edit_username_allowed          = optional(bool)
  })
  default  = null
  nullable = true
}

variable "otp_policy" {
  type = object({
    type              = optional(string)
    algorithm         = optional(string)
    initial_counter   = optional(number)
    digits            = optional(number)
    look_ahead_window = optional(number)
    period            = optional(number)
    code_reusable     = optional(bool)
  })
  default  = null
  nullable = true
}

variable "webauthn" {
  type = object({
    rp_entity_name                    = optional(string)
    rp_id                             = optional(string)
    signature_algorithms              = optional(list(string))
    attestation_conveyance_preference = optional(string)
    authenticator_attachment          = optional(string)
    require_resident_key              = optional(string)
    user_verification_requirement     = optional(string)
    create_timeout                    = optional(number)
    avoid_same_authenticator_register = optional(bool)
    acceptable_aaguids                = optional(list(string))
  })
  default  = null
  nullable = true
}

variable "webauthn_passwordless" {
  type = object({
    rp_entity_name                    = optional(string)
    rp_id                             = optional(string)
    signature_algorithms              = optional(list(string))
    attestation_conveyance_preference = optional(string)
    authenticator_attachment          = optional(string)
    require_resident_key              = optional(string)
    user_verification_requirement     = optional(string)
    create_timeout                    = optional(number)
    avoid_same_authenticator_register = optional(bool)
    acceptable_aaguids                = optional(list(string))
  })
  default  = null
  nullable = true
}

variable "event_settings" {
  type = object({
    admin_events_enabled         = optional(bool)
    admin_events_details_enabled = optional(bool)
    events_enabled               = optional(bool)
    enabled_event_types          = optional(list(string))
    events_expiration            = optional(number)
    events_listeners             = optional(list(string))
  })
  default  = null
  nullable = true
}

variable "realm_attributes" {
  type    = map(string)
  default = {}
}

variable "components" {
  description = "Scaffold only. Provider support varies by component type."
  type = list(object({
    name          = string
    provider_type = string
    provider_id   = string
    sub_type      = optional(string)
    config        = optional(map(list(string)), {})
  }))
  default = []
}

variable "organizations" {
  description = "Scaffold only. Fill when provider/resource support is available in your target version."
  type = list(object({
    name       = string
    domains    = optional(list(string), [])
    attributes = optional(map(string), {})
  }))
  default = []
}

variable "verifiable_credentials" {
  description = "Scaffold only. Keep as input data until your provider/version exposes dedicated resources."
  type = object({
    enabled   = bool
    format    = string
    algorithm = string
    extra     = optional(map(string), {})
  })
  default = {
    enabled   = false
    format    = ""
    algorithm = ""
    extra     = {}
  }
}

variable "default_realm_roles" {
  type    = list(string)
  default = []
}

variable "roles" {
  type = map(object({
    description = optional(string)
  }))
  default = {}
}

variable "groups" {
  type = map(object({
    attributes  = optional(map(list(string)), {})
    realm_roles = optional(list(string), [])
  }))
  default = {}
}

variable "users" {
  type = map(object({
    email          = string
    first_name     = string
    last_name      = string
    enabled        = optional(bool, true)
    email_verified = optional(bool, true)
    attributes     = optional(map(list(string)), {})
    groups         = optional(list(string), [])
    initial_password = object({
      value     = string
      temporary = bool
    })
  }))
  default   = {}
  sensitive = true
}

variable "ldap_federation" {
  type = object({
    enabled                 = optional(bool)
    name                    = optional(string)
    username_ldap_attribute = optional(string)
    rdn_ldap_attribute      = optional(string)
    uuid_ldap_attribute     = optional(string)
    user_object_classes     = optional(list(string))
    connection_url          = optional(string)
    users_dn                = optional(string)
    bind_dn                 = optional(string)
    bind_credential         = optional(string)
    auth_type               = optional(string)
    vendor                  = optional(string)
    edit_mode               = optional(string)
    import_enabled          = optional(bool)
    sync_registrations      = optional(bool)
    trust_email             = optional(bool)
    connection_timeout      = optional(string)
    read_timeout            = optional(string)
    pagination              = optional(bool)
    mappers = optional(list(object({
      name                        = string
      user_model_attribute        = string
      ldap_attribute              = string
      read_only                   = bool
      always_read_value_from_ldap = bool
    })), [])
  })
  default  = null
  nullable = true
}

variable "google_identity_provider" {
  type = object({
    enabled        = optional(bool)
    alias          = optional(string)
    display_name   = optional(string)
    client_id      = optional(string)
    client_secret  = optional(string)
    default_scopes = optional(string)
    mappers = optional(list(object({
      name           = string
      claim          = string
      user_attribute = string
      sync_mode      = string
    })), [])
    username_template = optional(object({
      enabled   = optional(bool)
      template  = string
      target    = optional(string)
      sync_mode = optional(string)
    }))
  })
  default  = null
  nullable = true
}

variable "azuread_identity_provider" {
  type = object({
    enabled        = optional(bool)
    alias          = optional(string)
    display_name   = optional(string)
    tenant_id      = optional(string)
    client_id      = optional(string)
    client_secret  = optional(string)
    default_scopes = optional(string)
    mappers = optional(list(object({
      name           = string
      claim          = string
      user_attribute = string
      sync_mode      = string
    })), [])
    username_template = optional(object({
      enabled   = optional(bool)
      template  = string
      target    = optional(string)
      sync_mode = optional(string)
    }))
  })
  default  = null
  nullable = true
}

variable "apple_identity_provider" {
  type = object({
    enabled        = optional(bool)
    alias          = optional(string)
    display_name   = optional(string)
    client_id      = optional(string)
    client_secret  = optional(string)
    default_scopes = optional(string)
    mappers = optional(list(object({
      name           = string
      claim          = string
      user_attribute = string
      sync_mode      = string
    })), [])
    username_template = optional(object({
      enabled   = optional(bool)
      template  = string
      target    = optional(string)
      sync_mode = optional(string)
    }))
  })
  default  = null
  nullable = true
}

variable "clients" {
  type = object({
    bearer_only = optional(map(object({
      client_id                 = string
      name                      = optional(string)
      description               = optional(string)
      enabled                   = optional(bool)
      client_secret             = optional(string)
      client_authenticator_type = optional(string)
      full_scope_allowed        = optional(bool)
      require_dpop_bound_tokens = optional(bool)
      roles = optional(map(object({
        name        = optional(string)
        description = optional(string)
      })), {})
      scope_mappings = optional(object({
        realm_roles = optional(list(string), [])
        client_roles = optional(list(object({
          client_type = string
          client_key  = string
          role_key    = string
        })), [])
      }), {})
      protocol_mappers = optional(map(object({
        name            = optional(string)
        protocol        = optional(string, "openid-connect")
        protocol_mapper = string
        config          = optional(map(string), {})
      })), {})
      extra_config = optional(map(string))
    })), {})

    confidential = optional(map(object({
      client_id                       = string
      root_url                        = string
      valid_redirect_uris             = list(string)
      web_origins                     = list(string)
      name                            = optional(string)
      description                     = optional(string)
      enabled                         = optional(bool)
      client_secret                   = optional(string)
      client_authenticator_type       = optional(string)
      base_url                        = optional(string)
      admin_url                       = optional(string)
      valid_post_logout_redirect_uris = optional(list(string))
      consent_required                = optional(bool)
      full_scope_allowed              = optional(bool)
      use_refresh_tokens              = optional(bool)
      pkce_code_challenge_method      = optional(string)
      require_dpop_bound_tokens       = optional(bool)
      standard_token_exchange_enabled = optional(bool)
      default_scopes                  = optional(list(string), ["profile", "email"])
      optional_scopes                 = optional(list(string), ["roles"])
      roles = optional(map(object({
        name        = optional(string)
        description = optional(string)
      })), {})
      scope_mappings = optional(object({
        realm_roles = optional(list(string), [])
        client_roles = optional(list(object({
          client_type = string
          client_key  = string
          role_key    = string
        })), [])
      }), {})
      protocol_mappers = optional(map(object({
        name            = optional(string)
        protocol        = optional(string, "openid-connect")
        protocol_mapper = string
        config          = optional(map(string), {})
      })), {})
      extra_config = optional(map(string))
    })), {})

    public = optional(map(object({
      client_id                       = string
      root_url                        = string
      valid_redirect_uris             = list(string)
      web_origins                     = list(string)
      name                            = optional(string)
      description                     = optional(string)
      enabled                         = optional(bool)
      base_url                        = optional(string)
      admin_url                       = optional(string)
      valid_post_logout_redirect_uris = optional(list(string))
      consent_required                = optional(bool)
      full_scope_allowed              = optional(bool)
      pkce_code_challenge_method      = optional(string)
      require_dpop_bound_tokens       = optional(bool)
      default_scopes                  = optional(list(string), ["profile", "email"])
      optional_scopes                 = optional(list(string), ["roles"])
      roles = optional(map(object({
        name        = optional(string)
        description = optional(string)
      })), {})
      scope_mappings = optional(object({
        realm_roles = optional(list(string), [])
        client_roles = optional(list(object({
          client_type = string
          client_key  = string
          role_key    = string
        })), [])
      }), {})
      protocol_mappers = optional(map(object({
        name            = optional(string)
        protocol        = optional(string, "openid-connect")
        protocol_mapper = string
        config          = optional(map(string), {})
      })), {})
      extra_config = optional(map(string))
    })), {})

    service_account = optional(map(object({
      client_id                             = string
      name                                  = optional(string)
      description                           = optional(string)
      enabled                               = optional(bool)
      client_secret                         = optional(string)
      client_authenticator_type             = optional(string)
      full_scope_allowed                    = optional(bool)
      require_dpop_bound_tokens             = optional(bool)
      standard_token_exchange_enabled       = optional(bool)
      use_refresh_tokens_client_credentials = optional(bool)
      default_scopes                        = optional(list(string), ["roles"])
      optional_scopes                       = optional(list(string), [])
      roles = optional(map(object({
        name        = optional(string)
        description = optional(string)
      })), {})
      scope_mappings = optional(object({
        realm_roles = optional(list(string), [])
        client_roles = optional(list(object({
          client_type = string
          client_key  = string
          role_key    = string
        })), [])
      }), {})
      service_account_roles = optional(object({
        realm_roles = optional(list(string), [])
        client_roles = optional(list(object({
          client_type = string
          client_key  = string
          role_key    = string
        })), [])
      }), {})
      protocol_mappers = optional(map(object({
        name            = optional(string)
        protocol        = optional(string, "openid-connect")
        protocol_mapper = string
        config          = optional(map(string), {})
      })), {})
      extra_config = optional(map(string))
    })), {})
  })

  default = {}
}
