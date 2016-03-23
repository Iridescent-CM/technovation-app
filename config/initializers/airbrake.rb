Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
  config.project_key = ENV['AIRBRAKE_PROJECT_ID']
end
