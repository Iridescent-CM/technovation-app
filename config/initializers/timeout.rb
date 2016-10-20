unless Rails.env.development? or Rails.env.test?
  Rack::Timeout.timeout = 29
end
