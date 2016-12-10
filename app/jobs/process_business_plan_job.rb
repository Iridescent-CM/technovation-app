class ProcessBusinessPlanJob < ActiveJob::Base
  queue_as :default

  def perform(record, key)
    url = "http://s3.amazonaws.com/#{ENV.fetch("AWS_BUCKET_NAME")}/#{key}"
    record.create_business_plan!({
      remote_uploaded_file_url: url,
    })
  end
end
