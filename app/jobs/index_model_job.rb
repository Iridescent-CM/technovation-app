class IndexModelJob < ActiveJob::Base
  queue_as :elasticsearch

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new host: ENV.fetch("BONSAI_URL"), logger: Logger

  @@force_refresh = false

  def self.force_refresh(v)
    @@force_refresh = v
  end

  def perform(operation, klassname, id)
    logger.debug [operation, klassname, "ID: #{id}"]
    klass = Object.const_get klassname

    case operation.to_s
      when /index/
        record = klass.find(id)

        Client.index index: klass.index_name, type: klass.document_type, id: record.id, body: record.as_indexed_json, refresh: @@force_refresh
      when /delete/
        Client.delete index: klass.index_name, type: klass.document_type, id: id, refresh: @@force_refresh
      else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
