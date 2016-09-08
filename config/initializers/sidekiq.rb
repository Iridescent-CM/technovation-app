if Rails.env.production? or Rails.env.qa?
  Sidekiq.configure_client do |config|
    config.redis = { size: 3, url: ENV["REDIS_URL"] }
  end

  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'] }
  end
end
