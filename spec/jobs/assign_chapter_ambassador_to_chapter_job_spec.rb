require "rails_helper"

RSpec.describe AssignChapterAmbassadorToChapterJob do
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
    allow(UserInvitation).to receive(:find_by)
      .with(admin_permission_token: registration_invite.admin_permission_token)
      .and_return(registration_invite)

    allow(ChapterAmbassadorProfile).to receive(:find)
      .with(chapter_ambassador.id)
      .and_return(chapter_ambassador)
  end

  it "assigns the chapter from the invite to the chapter ambassador" do
    AssignChapterAmbassadorToChapterJob.perform_now(
      invite_code: registration_invite.admin_permission_token,
      chapter_ambassador_profile_id: chapter_ambassador.id
    )

    expect(chapter_ambassador.chapter_id).to eq(registration_invite.chapter_id)
  end
end
