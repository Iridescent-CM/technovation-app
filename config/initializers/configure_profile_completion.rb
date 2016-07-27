require "./app/technovation/profile_completion"

ProfileCompletion.configure do |config|
  config.path = "./config/completion_steps.yml.erb"
end
