require "fantaskspec"
Rails.application.load_tasks
RSpec.configure do |config|
  config.infer_rake_task_specs_from_file_location!
end
