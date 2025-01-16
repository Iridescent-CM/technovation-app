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

  it "calls the job that will setup the new club ambassador profile in the CRM" do
    expect(CRM::SetupAccountForCurrentSeasonJob).to receive(:perform_later)
      .with(
        account_id: account.id,
        profile_type: "club ambassador"
      )

    club_ambassador_profile_addition.call
  end
end
