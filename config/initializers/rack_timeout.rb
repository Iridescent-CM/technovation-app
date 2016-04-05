Rack::Timeout.service_timeout = 20
Rack::Timeout.unregister_state_change_observer(:logger) if Rails.env.development?
