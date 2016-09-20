module Legacy
  class LegacyModel < ActiveRecord::Base
    self.abstract_class = true

    @@config = ENV['LEGACY_DATABASE_URL'] || connection_config.dup
    @@config[:database] = "technovation_development" unless ENV['LEGACY_DATABASE_URL']
    establish_connection(@@config)

    def s3_credentials
      { s3_region: "us-east-1",
        bucket: "technovation-attachments-test",
        access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
        secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY") }
    end
  end
end
