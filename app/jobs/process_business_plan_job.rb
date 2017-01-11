class ProcessBusinessPlanJob < ActiveJob::Base
  queue_as :default

  def perform(record, key)
    url = "http://s3.amazonaws.com/#{ENV.fetch("AWS_BUCKET_NAME")}/#{key}"
    business_plan = record.business_plan || record.create_business_plan!
    business_plan.update_attributes({
      file_uploaded: true,
      remote_uploaded_file_url: url,
    })
  end
end
