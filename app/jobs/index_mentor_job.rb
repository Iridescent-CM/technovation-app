class IndexMentorJob < ActiveJob::Base
  queue_as :default

  def perform(record)
    client = Swiftype::Client.new
    client.create_or_update_document(ENV.fetch('SWIFTYPE_ENGINE_SLUG'),
                                     record.class.model_name.name.downcase,
                                     { external_id: record.id,
                                       fields: [{ name: 'title', value: record.search_name, type: 'string' },
                                                { name: 'created_at', value: record.created_at.iso8601, type: 'date' }] })
  end
end
