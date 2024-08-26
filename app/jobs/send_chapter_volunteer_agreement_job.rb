class SendChapterVolunteerAgreementJob < ActiveJob::Base
  queue_as :default

  def perform(chapter_ambassador_profile_id:)
    chapter_ambassador_profile = ChapterAmbassadorProfile.find(chapter_ambassador_profile_id)

    Docusign::ApiClient.new.send_chapter_volunteer_agreement(
      chapter_ambassador_profile: chapter_ambassador_profile
    )
  end
end
