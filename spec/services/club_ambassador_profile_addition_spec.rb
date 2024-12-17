require "rails_helper"

describe ClubAmbassadorProfileAddition do
  let(:club_ambassador_profile_addition) {
    ClubAmbassadorProfileAddition.new(account: account)
  }
  let(:mentor_profile) { FactoryBot.create(:mentor) }
  let(:account) { mentor_profile.account }

  it "creates a club ambassador proile for the account" do
    club_ambassador_profile_addition.call

    expect(account.club_ambassador_profile).to be_present
  end
end
