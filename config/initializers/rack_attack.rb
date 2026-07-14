# frozen_string_literal: true

class Rack::Attack
  SIGNINS_LIMIT = 20
  SIGNINS_PERIOD = 60
  PASSWORD_RESETS_LIMIT = 5
  PASSWORD_RESETS_PERIOD = 60
end

Rack::Attack.cache.store = if Rails.application.config.cache_store == :null_store
  ActiveSupport::Cache::MemoryStore.new
else
  Rails.cache
end

Rack::Attack.enabled = !Rails.env.test?

if Rails.env.development?
  Rack::Attack.safelist("allow localhost") do |req|
    ["127.0.0.1", "::1"].include?(req.ip)
  end
end

Rack::Attack.throttle(
  "signins/ip",
  limit: Rack::Attack::SIGNINS_LIMIT,
  period: Rack::Attack::SIGNINS_PERIOD.seconds
) do |req|
  req.ip if req.post? && req.path == "/signins"
end

Rack::Attack.throttle(
  "password_resets/ip",
  limit: Rack::Attack::PASSWORD_RESETS_LIMIT,
  period: Rack::Attack::PASSWORD_RESETS_PERIOD.seconds
) do |req|
  req.ip if req.post? && req.path == "/password_resets"
end

Rack::Attack.throttled_responder = lambda do |_request|
  [
    429,
    {"Content-Type" => "text/plain"},
    [I18n.t("controllers.rack_attack.throttled")]
  ]
end
