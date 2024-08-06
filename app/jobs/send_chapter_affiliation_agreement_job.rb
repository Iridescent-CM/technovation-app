class SendChapterAffiliationAgreementJob < ActiveJob::Base
  queue_as :default

  def perform(chapter_id:)
    chapter = Chapter.find(chapter_id)

    Docusign::ApiClient.new.send_chapter_affiliation_agreement(
      legal_contact: chapter.legal_contact
    )
  end
end
