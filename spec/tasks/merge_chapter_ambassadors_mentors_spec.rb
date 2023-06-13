require "rails_helper"
require "./lib/merge_chapter_ambassador_mentors"

RSpec.describe MergeChapterAmbassadorMentors do
  let!(:mentor) { FactoryBot.create(
    :mentor,
    :onboarded,
    account: FactoryBot.create(:account, email: "mentor@example.com")
  ) }

  let!(:chapter_ambassador) { FactoryBot.create(
    :ambassador,
    account: FactoryBot.create(:account, email: "mentor+chapter_ambassador@example.com")
  ) }

  before do
    ActionMailer::Base.deliveries.clear

    filepath = "./tmp/mergers.csv"

    CSV.open(filepath, "wb") do |csv|
      csv << %w{ra_email mentor_email desired_email}
      csv << %w{mentor+chapter_ambassador@example.com mentor@example.com chapter_ambassador@example.com}
    end

    merge = MergeChapterAmbassadorMentors.new(filepath)
    merge.perform
  end

  xit "merges a mentor profile into a chapter ambassador's account" do
    expect(MentorProfile.exists?(mentor.id)).not_to be true
    expect(chapter_ambassador.account.reload.mentor_profile).to be_present
  end

  xit "updates the chapter ambassadors email to the desired email" do
    expect(chapter_ambassador.reload.email).to eq("chapter_ambassador@example.com")
  end

  it "confirms the new email address without an email message workflow" do
    expect(ActionMailer::Base.deliveries).to be_empty
    expect(chapter_ambassador.reload.account).to be_email_confirmed
  end
end
