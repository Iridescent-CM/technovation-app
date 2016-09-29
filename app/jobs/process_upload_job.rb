class ProcessUploadJob < ActiveJob::Base
  queue_as :default

  def perform(record, method_name, key)
    url = "http://s3.amazonaws.com/#{ENV.fetch("AWS_BUCKET_NAME")}/#{key}"
    record.send("remote_#{method_name}_url=", url)
    record.save!
  end
end
