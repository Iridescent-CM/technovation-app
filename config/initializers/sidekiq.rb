if Rails.env.production? or Rails.env.qa?
  Sidekiq.configure_client do |config|
    config.redis = { size: 3, url: ENV["REDIS_URL"], namespace: "technovation" }
  end

  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'], namespace: "technovation" }

    Rails.application.config.after_initialize do
      Rails.logger.info("DB Connection Pool size for Sidekiq Server before disconnect is: #{ActiveRecord::Base.connection.pool.instance_variable_get('@size')}")
      ActiveRecord::Base.connection_pool.disconnect!

      ActiveSupport.on_load(:active_record) do
        config = Rails.application.config.database_configuration[Rails.env]
        config['reaping_frequency'] = ENV['DATABASE_REAP_FREQ'] || 10 # seconds
        config['pool'] = Sidekiq.options[:concurrency]
        ActiveRecord::Base.establish_connection(config)

        Rails.logger.info("DB Connection Pool size for Sidekiq Server is now: #{ActiveRecord::Base.connection.pool.instance_variable_get('@size')}")
      end
    end
  end
end
