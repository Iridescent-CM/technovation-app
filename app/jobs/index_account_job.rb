class IndexAccountJob < ActiveJob::Base
  queue_as :elasticsearch

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new host: ENV.fetch("BONSAI_URL"), logger: Logger

  def perform(operation, id)
    logger.debug [operation, "ID: #{id}"]

    case operation.to_s
      when /index/
        record = Account.find(id)

        Client.index index: "accounts", type: "account", id: record.id, body: record.as_indexed_json
      when /delete/
        Client.delete index: "accounts", type: "account", id: id
      else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
