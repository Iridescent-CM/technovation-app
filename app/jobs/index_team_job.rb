class IndexTeamJob < ActiveJob::Base
  queue_as :elasticsearch

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new host: ENV.fetch("BONSAI_URL"), logger: Logger

  def perform(operation, id)
    logger.debug [operation, "ID: #{id}"]

    case operation.to_s
      when /index/
        record = Team.find(id)

        Client.index index: "#{Rails.env}_teams", type: "team", id: record.id, body: record.as_indexed_json
      when /delete/
        Client.delete index: "#{Rails.env}_teams", type: "team", id: id
      else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
