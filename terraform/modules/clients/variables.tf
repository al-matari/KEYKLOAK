variable "realm_id" {
  type = string
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
