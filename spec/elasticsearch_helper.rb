require 'elasticsearch/model'

module ElasticsearchHelper
  class << self
    attr_accessor :urls_regex
    attr_accessor :hosts
  end
  client = Elasticsearch::Client.new url: ENV.fetch('BONSAI_URL')
  hosts_config = client.transport.hosts

  self.hosts = hosts_config.collect {|c| c[:host] }

  urls = hosts_config.map {|c| URI::HTTP.build(c)}
  self.urls_regex = /#{urls.join("|")}/
end
