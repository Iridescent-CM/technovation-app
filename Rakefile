# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
if Rails.env.development? || Rails.env.test?
  require 'seedbank'
  Seedbank.load_tasks if defined?(Seedbank)
end

Rails.application.load_tasks
