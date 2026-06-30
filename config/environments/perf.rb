# Local Lighthouse captures (perf/scripts/start-prod-server.sh).
# Production boot settings with HTTP on localhost — no SSL redirects or assumed HTTPS.
load Rails.root.join("config/environments/production.rb").to_s

Rails.application.configure do
  config.assume_ssl = false
  config.force_ssl = false

  protocol = "http://"
  host = ENV.fetch("HOST_DOMAIN")
  config.action_mailer.asset_host = "#{protocol}#{host}"
  config.action_controller.asset_host = "#{protocol}#{host}"
end
