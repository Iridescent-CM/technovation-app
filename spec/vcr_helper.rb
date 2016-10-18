require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock # or :fakeweb
  config.configure_rspec_metadata!
  config.ignore_localhost = true
end
