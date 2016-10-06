class IndexAccountJob < ActiveJob::Base
  queue_as :default

  def perform(record)
    client = Swiftype::Client.new
    client.create_or_update_document(ENV.fetch('SWIFTYPE_ENGINE_SLUG'),
                                     "adminaccounts",
                                     { external_id: record.id,
                                       fields: [{ name: 'name', value: record.full_name, type: 'string' },
                                                { name: 'email', value: record.email, type: 'string' },
                                                { name: 'id', value: record.id, type: 'integer' },
                                                { name: 'created_at', value: record.created_at.iso8601, type: 'date' }] })
  end
end
