require_relative 'controller_helpers'

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :view
  config.include ControllerHelpers, type: :controller
end
