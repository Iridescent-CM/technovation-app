# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'airbrake/rake/tasks'
require 'churn'

ENV['CHURN_START_DATE'] = "2016-09-01"
ENV['CHURN_IGNORES'] = "db,Gemfile,log,config"

Rails.application.load_tasks
