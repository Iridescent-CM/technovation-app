class AssignAmbassadorToChapterableJob < ActiveJob::Base
  queue_as :default

  def perform(invite_code:, ambassador_profile_id:)
    invite = UserInvitation.find_by(admin_permission_token: invite_code)

    if invite.present?
      if invite.profile_type == "chapter_ambassador"
        ambassador_profile = ChapterAmbassadorProfile.find(ambassador_profile_id)
        chapterable_type = "Chapter"
        chapterable_id = invite.chapter_id
      elsif invite.profile_type == "club_ambassador"
        ambassador_profile = ClubAmbassadorProfile.find(ambassador_profile_id)
        chapterable_type = "Club"
        chapterable_id = invite.club_id
      end

      if ambassador_profile.present?
        ambassador_profile.account.chapterable_assignments.create(
          profile: ambassador_profile,
          chapterable_id: chapterable_id,
          chapterable_type: chapterable_type,
          season: Season.current.year,
          primary: true
        )
      end
    end
  end
end
