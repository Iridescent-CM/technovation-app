Airbrake.configure do |config|
  config.project_key = ENV.fetch('AIRBRAKE_API_KEY', '')
  config.project_id = ENV.fetch('AIRBRAKE_PROJECT_ID', '')

  config.logger.level = Logger::DEBUG
  config.environment = Rails.env
end
