class ProcessUploadJob < ActiveJob::Base
  queue_as :default

  def perform(record_id, klass, method_name, key)
    record = klass.constantize.find(record_id)
    url = "http://s3.amazonaws.com/#{ENV.fetch("AWS_BUCKET_NAME")}/#{key}"
    record.send("remote_#{method_name}_url=", url)

    case method_name
    when "source_code"
      record.source_code_file_uploaded = true
    end

    record.save!
  end
end
