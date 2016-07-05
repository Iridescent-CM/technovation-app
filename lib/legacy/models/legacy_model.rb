module Legacy
  class LegacyModel < ActiveRecord::Base
    self.abstract_class = true

    @@config = connection_config
    @@config[:database] = "technovation_development"
    establish_connection(@@config)
  end
end
