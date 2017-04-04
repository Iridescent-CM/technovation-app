require 'vcr'
require 'webmock/rspec'

LOCALHOSTS = %w( localhost 127.0.0.1 0.0.0.0 )

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock # or :fakeweb
  config.configure_rspec_metadata!
  config.ignore_request do |request|
    uri = URI(request.uri)
    LOCALHOSTS.include?(uri.host) and uri.port != 9200
  end
end
