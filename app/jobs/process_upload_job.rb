class ProcessUploadJob < ActiveJob::Base
  queue_as :default

  def perform(record, method_name, key)
    record.key = key
    url = "#{record.send(method_name).direct_fog_url}#{record.key}"
    record.send("remote_#{method_name}_url=", url)
    record.save!
  end
end
