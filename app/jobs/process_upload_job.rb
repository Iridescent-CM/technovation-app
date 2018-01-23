class ProcessUploadJob < ActiveJob::Base
  queue_as :default

  def perform(record_id, klass, method_name, key, account_id = nil)
    record = klass.constantize.find(record_id)
    url = "http://s3.amazonaws.com/#{ENV.fetch("AWS_BUCKET_NAME")}/#{key}"
    record.send("remote_#{method_name}_url=", url)

    case klass
    when "Account"
      record.icon_path = nil
    end

    record.save!
  end
end
