module Legacy
  class LegacyModel < ActiveRecord::Base
    self.abstract_class = true

    @@config = ENV['LEGACY_DATABASE_URL'] || connection_config.dup
    @@config[:database] = "technovation_development" unless ENV['LEGACY_DATABASE_URL']
    establish_connection(@@config)
  end
end
