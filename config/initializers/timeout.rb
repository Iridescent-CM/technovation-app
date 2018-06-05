unless Rails.env.development? or Rails.env.test?
  Rack::Timeout.service_timeout = 29
end
