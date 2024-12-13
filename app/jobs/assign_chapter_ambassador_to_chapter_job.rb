class AssignChapterAmbassadorToChapterJob < ActiveJob::Base
  queue_as :default

  def perform(invite_code:, chapter_ambassador_profile_id:)
    invite = UserInvitation.find_by(admin_permission_token: invite_code)
    chapter_ambassador = ChapterAmbassadorProfile.find(chapter_ambassador_profile_id)

    if invite.present? && invite.chapter_id.present?
      chapter_ambassador.account.chapterable_assignments.create(
        profile: chapter_ambassador,
        chapterable_id: invite.chapter_id,
        chapterable_type: "Chapter",
        season: Season.current.year,
        primary: true
      )
    end
  end
end
