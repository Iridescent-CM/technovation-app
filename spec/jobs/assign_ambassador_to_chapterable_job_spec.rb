require "rails_helper"

RSpec.describe AssignAmbassadorToChapterableJob do
  context "when the invite is for a chapter ambassador" do
    let(:registration_invite) {
      UserInvitation.create!(
        profile_type: :chapter_ambassador,
        email: "chapter_ambassador_invite@example.com",
        chapter_id: chapter.id
      )
    }
    let(:chapter) { FactoryBot.create(:chapter) }
    let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }

    before do
      chapter_ambassador.account.chapters.delete_all

      allow(UserInvitation).to receive(:find_by)
        .with(admin_permission_token: registration_invite.admin_permission_token)
        .and_return(registration_invite)

      allow(ChapterAmbassadorProfile).to receive(:find)
        .with(chapter_ambassador.id)
        .and_return(chapter_ambassador)
    end

    it "assigns the chapter from the invite to the chapter ambassador" do
      AssignAmbassadorToChapterableJob.perform_now(
        invite_code: registration_invite.admin_permission_token,
        ambassador_profile_id: chapter_ambassador.id
      )

      expect(chapter_ambassador.account.current_chapter.id).to eq(registration_invite.chapter_id)
    end
  end

  context "when the invite is for a club ambassador" do
    let(:registration_invite) {
      UserInvitation.create!(
        profile_type: :club_ambassador,
        email: "chapter_ambassador_invite@example.com",
        club_id: club.id
      )
    }
    let(:club) { FactoryBot.create(:club) }
    let(:club_ambassador) { FactoryBot.create(:club_ambassador) }

    before do
      club_ambassador.account.reload
      club_ambassador.account.clubs.delete_all

      allow(UserInvitation).to receive(:find_by)
        .with(admin_permission_token: registration_invite.admin_permission_token)
        .and_return(registration_invite)

      allow(ClubAmbassadorProfile).to receive(:find)
        .with(club_ambassador.id)
        .and_return(club_ambassador)
    end

    it "assigns the club from the invite to the club ambassador" do
      AssignAmbassadorToChapterableJob.perform_now(
        invite_code: registration_invite.admin_permission_token,
        ambassador_profile_id: club_ambassador.id
      )

      expect(club_ambassador.account.current_club.id).to eq(registration_invite.club_id)
    end
  end
end
