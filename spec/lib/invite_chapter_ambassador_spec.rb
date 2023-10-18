require "rails_helper"

RSpec.describe InviteChapterAmbassador do
  it "doesn't replace existing approved chapter ambassadors" do
    chapter_ambassador = FactoryBot.create(:ambassador, :approved)

    account = FactoryBot.build(:account, email: chapter_ambassador.email)

    invited = InviteChapterAmbassador.(account.attributes)

    expect(invited).to be_nil
  end

  it "replaces any student or judge account found" do
    %w{student judge}.each do |scope|
      existing = FactoryBot.create(scope).account
      account = FactoryBot.build(:account, email: existing.email)
      invited_account = nil

      expect {
        invited_account = InviteChapterAmbassador.(
          account.attributes.merge(FactoryBot.attributes_for(:ambassador))
        )
      }.to change {
        existing.reload.deleted?
      }.from(false).to(true)

      expect(invited_account).not_to be_nil
      expect(invited_account.id).not_to be_nil
      expect(invited_account.id).to eq(existing.id)
    end
  end

  it "re-assigns existing mentor profiles" do
    mentor = FactoryBot.create(:mentor, job_title: "Custom job title")
    account = FactoryBot.build(:account, email: mentor.email.upcase)

    invited_account = InviteChapterAmbassador.(
      account.attributes.merge(FactoryBot.attributes_for(:ambassador))
    )

    expect(invited_account.mentor_profile.job_title).to eq("Custom job title")
  end

  it "re-assigns existing background checks" do
    mentor = FactoryBot.create(:mentor)
    mentor.background_check.update({
      report_id: "unique-for-this-test",
      candidate_id: "also-unique-for-this-test",
    })

    account = FactoryBot.build(:account, email: mentor.email)

    invited_account = InviteChapterAmbassador.(
      account.attributes.merge(FactoryBot.attributes_for(:ambassador))
    )

    bg_check = invited_account.background_check
    expect(bg_check.report_id).to eq("unique-for-this-test")
    expect(bg_check.candidate_id).to eq("also-unique-for-this-test")
    expect(invited_account.mentor_profile).to be_background_check_complete
  end
end
