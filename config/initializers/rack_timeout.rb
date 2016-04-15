if !Rails.env.development? && !Rails.env.test?
  Rack::Timeout.service_timeout = 29
  Rack::Timeout.unregister_state_change_observer(:logger) if Rails.env.development?
end
