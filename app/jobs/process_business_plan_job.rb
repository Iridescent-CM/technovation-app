class ProcessBusinessPlanJob < ActiveJob::Base
  queue_as :default

  def perform(submission_id, key)
    submission = TeamSubmission.find(submission_id)
    url = "http://s3.amazonaws.com/#{ENV.fetch("AWS_BUCKET_NAME")}/#{key}"
    business_plan = submission.business_plan || submission.create_business_plan!
    business_plan.update({
      remote_uploaded_file_url: url
    })
  end
end
