# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store,
 key: "_technovation_challenge",
 domain: ENV.fetch("COOKIE_DOMAIN")
