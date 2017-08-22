module HerokuDeflater
  class CacheControlManager
    def cache_control_headers
      app.config.public_file_server.headers
    end
  end
end
