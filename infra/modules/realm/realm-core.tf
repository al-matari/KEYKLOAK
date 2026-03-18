resource "keycloak_realm" "this" {
  realm        = var.realm_name
  enabled      = true
  display_name = var.display_name

  registration_allowed           = try(var.login_settings.registration_allowed, null)
  registration_email_as_username = try(var.login_settings.registration_email_as_username, null)
  remember_me                    = try(var.login_settings.remember_me, null)
  verify_email                   = try(var.login_settings.verify_email, null)
  login_with_email_allowed       = try(var.login_settings.login_with_email_allowed, null)
  duplicate_emails_allowed       = try(var.login_settings.duplicate_emails_allowed, null)
  reset_password_allowed         = try(var.login_settings.reset_password_allowed, null)
  edit_username_allowed          = try(var.login_settings.edit_username_allowed, null)

  password_policy = var.password_policy

  access_code_lifespan_login               = try(var.token_settings.access_code_lifespan_login, null)
  access_token_lifespan                    = try(var.token_settings.access_token_lifespan, null)
  access_token_lifespan_for_implicit_flow  = try(var.token_settings.access_token_lifespan_for_implicit_flow, null)
  action_token_generated_by_admin_lifespan = try(var.token_settings.action_token_generated_by_admin_lifespan, null)
  action_token_generated_by_user_lifespan  = try(var.token_settings.action_token_generated_by_user_lifespan, null)

  sso_session_idle_timeout             = try(var.session_settings.sso_session_idle_timeout, null)
  sso_session_max_lifespan             = try(var.session_settings.sso_session_max_lifespan, null)
  sso_session_idle_timeout_remember_me = try(var.session_settings.sso_session_idle_timeout_remember_me, null)
  sso_session_max_lifespan_remember_me = try(var.session_settings.sso_session_max_lifespan_remember_me, null)
  client_session_idle_timeout          = try(var.session_settings.client_session_idle_timeout, null)
  client_session_max_lifespan          = try(var.session_settings.client_session_max_lifespan, null)
  offline_session_idle_timeout         = try(var.session_settings.offline_session_idle_timeout, null)
  offline_session_max_lifespan_enabled = try(var.session_settings.offline_session_max_lifespan_enabled, null)
  offline_session_max_lifespan         = try(var.session_settings.offline_session_max_lifespan, null)

  dynamic "otp_policy" {
    for_each = var.otp_policy != null ? [var.otp_policy] : []

    content {
      type              = try(otp_policy.value.type, null)
      algorithm         = try(otp_policy.value.algorithm, null)
      initial_counter   = try(otp_policy.value.initial_counter, null)
      digits            = try(otp_policy.value.digits, null)
      look_ahead_window = try(otp_policy.value.look_ahead_window, null)
      period            = try(otp_policy.value.period, null)
    }
  }

  dynamic "web_authn_policy" {
    for_each = var.webauthn != null ? [var.webauthn] : []

    content {
      relying_party_entity_name         = try(web_authn_policy.value.rp_entity_name, null)
      relying_party_id                  = try(web_authn_policy.value.rp_id, null)
      signature_algorithms              = try(web_authn_policy.value.signature_algorithms, null)
      attestation_conveyance_preference = try(web_authn_policy.value.attestation_conveyance_preference, null)
      authenticator_attachment          = try(web_authn_policy.value.authenticator_attachment, null)
      require_resident_key              = try(web_authn_policy.value.require_resident_key, null)
      user_verification_requirement     = try(web_authn_policy.value.user_verification_requirement, null)
      create_timeout                    = try(web_authn_policy.value.create_timeout, null)
      avoid_same_authenticator_register = try(web_authn_policy.value.avoid_same_authenticator_register, null)
      acceptable_aaguids                = try(web_authn_policy.value.acceptable_aaguids, null)
    }
  }

  dynamic "web_authn_passwordless_policy" {
    for_each = var.webauthn_passwordless != null ? [var.webauthn_passwordless] : []

    content {
      relying_party_entity_name         = try(web_authn_passwordless_policy.value.rp_entity_name, null)
      relying_party_id                  = try(web_authn_passwordless_policy.value.rp_id, null)
      signature_algorithms              = try(web_authn_passwordless_policy.value.signature_algorithms, null)
      attestation_conveyance_preference = try(web_authn_passwordless_policy.value.attestation_conveyance_preference, null)
      authenticator_attachment          = try(web_authn_passwordless_policy.value.authenticator_attachment, null)
      require_resident_key              = try(web_authn_passwordless_policy.value.require_resident_key, null)
      user_verification_requirement     = try(web_authn_passwordless_policy.value.user_verification_requirement, null)
      create_timeout                    = try(web_authn_passwordless_policy.value.create_timeout, null)
      avoid_same_authenticator_register = try(web_authn_passwordless_policy.value.avoid_same_authenticator_register, null)
      acceptable_aaguids                = try(web_authn_passwordless_policy.value.acceptable_aaguids, null)
    }
  }

  dynamic "internationalization" {
    for_each = var.localization != null ? [var.localization] : []

    content {
      supported_locales = try(internationalization.value.supported_locales, null)
      default_locale    = try(internationalization.value.default_locale, null)
    }
  }

  dynamic "security_defenses" {
    for_each = var.security_headers != null || var.brute_force != null ? [1] : []

    content {
      dynamic "headers" {
        for_each = var.security_headers != null ? [var.security_headers] : []

        content {
          x_frame_options           = try(headers.value.x_frame_options, null)
          content_security_policy   = try(headers.value.content_security_policy, null)
          x_content_type_options    = try(headers.value.x_content_type_options, null)
          x_xss_protection          = try(headers.value.x_xss_protection, null)
          strict_transport_security = try(headers.value.strict_transport_security, null)
          referrer_policy           = try(headers.value.referrer_policy, null)
        }
      }

      dynamic "brute_force_detection" {
        for_each = var.brute_force != null ? [var.brute_force] : []

        content {
          permanent_lockout                = try(brute_force_detection.value.permanent_lockout, null)
          max_login_failures               = try(brute_force_detection.value.max_login_failures, null)
          wait_increment_seconds           = try(brute_force_detection.value.wait_increment_seconds, null)
          quick_login_check_milli_seconds  = try(brute_force_detection.value.quick_login_check_milli_seconds, null)
          minimum_quick_login_wait_seconds = try(brute_force_detection.value.minimum_quick_login_wait_seconds, null)
          max_failure_wait_seconds         = try(brute_force_detection.value.max_failure_wait_seconds, null)
          failure_reset_time_seconds       = try(brute_force_detection.value.failure_reset_time_seconds, null)
        }
      }
    }
  }

  login_theme   = try(var.themes.login_theme, null)
  account_theme = try(var.themes.account_theme, null)
  admin_theme   = try(var.themes.admin_theme, null)
  email_theme   = try(var.themes.email_theme, null)

  dynamic "smtp_server" {
    for_each = var.smtp != null ? [var.smtp] : []

    content {
      host                  = try(smtp_server.value.host, null)
      port                  = try(smtp_server.value.port, null) != null ? tostring(smtp_server.value.port) : null
      from                  = try(smtp_server.value.from, null)
      from_display_name     = try(smtp_server.value.from_display_name, null)
      reply_to              = try(smtp_server.value.reply_to, null)
      reply_to_display_name = try(smtp_server.value.reply_to_display_name, null)
      envelope_from         = try(smtp_server.value.envelope_from, null)
      ssl                   = try(smtp_server.value.ssl, null)
      starttls              = try(smtp_server.value.starttls, null)

      dynamic "auth" {
        for_each = trimspace(try(smtp_server.value.auth_username, "")) != "" && trimspace(try(smtp_server.value.auth_password, "")) != "" ? [smtp_server.value] : []

        content {
          username = auth.value.auth_username
          password = auth.value.auth_password
        }
      }
    }
  }

  # Keep scaffold-only inputs visible in realm metadata until dedicated resources are introduced.
  attributes = merge(
    var.realm_attributes,
    {
      for key, value in {
        "x-template/components_count"       = tostring(length(var.components))
        "x-template/organizations_count"    = tostring(length(var.organizations))
        "x-template/verifiable_credentials" = tostring(coalesce(try(var.verifiable_credentials.enabled, null), false))
        "x-template/events_enabled"         = try(var.event_settings.events_enabled, null) == null ? null : tostring(var.event_settings.events_enabled)
        "x-template/admin_events_enabled"   = try(var.event_settings.admin_events_enabled, null) == null ? null : tostring(var.event_settings.admin_events_enabled)
        "x-template/events_listeners"       = try(var.event_settings.events_listeners, null) == null ? null : join(",", var.event_settings.events_listeners)
        "x-template/enabled_event_types"    = try(var.event_settings.enabled_event_types, null) == null ? null : join(",", var.event_settings.enabled_event_types)
        "x-template/events_expiration"      = try(var.event_settings.events_expiration, null) == null ? null : tostring(var.event_settings.events_expiration)
        "x-template/otp_code_reusable"      = try(var.otp_policy.code_reusable, null) == null ? null : tostring(var.otp_policy.code_reusable)
      } : key => value
      if value != null
    }
  )
}
