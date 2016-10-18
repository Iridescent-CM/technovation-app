require 'elasticsearch/model'
require 'elasticsearch/rails'

url = ENV.fetch('BONSAI_URL')
url_safe = url.gsub(/\:[a-z0-9]{1,}@/, ":redacted@")
Rails.logger.info("Starting up a new Bonsai Elasticsearch client with url: #{url_safe}")
Elasticsearch::Model.client = Elasticsearch::Client.new url: url
