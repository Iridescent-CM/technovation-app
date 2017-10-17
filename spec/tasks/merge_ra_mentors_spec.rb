require "rails_helper"
require "./lib/merge_ra_mentors"

RSpec.describe MergeRAMentors do
  let!(:mentor) { FactoryGirl.create(:mentor, email: "mentor@ra.com") }
  let!(:ra) { FactoryGirl.create(:ambassador, email: "mentor+ra@ra.com") }

  before do
    ActionMailer::Base.deliveries.clear

    filepath = "./tmp/mergers.csv"

    CSV.open(filepath, "wb") do |csv|
      csv << %w{ra_email mentor_email desired_email}
      csv << %w{mentor+ra@ra.com mentor@ra.com ra@ra.com}
    end

    merge = MergeRAMentors.new(filepath)
    merge.perform
  end

  it "merges a mentor profile into an RA's account" do
    expect(MentorProfile.exists?(mentor.id)).not_to be true
    expect(ra.account.mentor_profile).to be_present
  end

  it "updates the RAs email to the desired email" do
    expect(ra.reload.email).to eq("ra@ra.com")
  end

  it "confirms the new email address without an email message workflow" do
    expect(ActionMailer::Base.deliveries).to be_empty
    expect(ra.reload.account).to be_email_confirmed
  end
end
