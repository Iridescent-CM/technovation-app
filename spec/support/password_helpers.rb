module PasswordHelpers
  VALID_PASSWORD = "Secret1234"
  VALID_ADMIN_PASSWORD = "ComplexAdminPassword1"
end

RSpec.configure do |config|
  config.include PasswordHelpers
end
