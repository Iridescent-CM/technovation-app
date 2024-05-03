class SendMemorandumOfUnderstandingJob < ActiveJob::Base
  queue_as :default

  def perform(chapter_id:)
    chapter = Chapter.find(chapter_id)

    Docusign::ApiClient.new.send_memorandum_of_understanding(
      legal_contact: chapter.legal_contact
    )
  end
end
