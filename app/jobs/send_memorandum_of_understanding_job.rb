class SendMemorandumOfUnderstandingJob < ActiveJob::Base
  queue_as :default

  def perform(full_name:, email_address:, organization_name:, job_title: nil)
    Docusign::ApiClient.new.send_memorandum_of_understanding(
      full_name: full_name,
      email_address: email_address,
      organization_name: organization_name,
      job_title: job_title
    )
  end
end
