require "rails_helper"

RSpec.describe Account do
  subject(:account) { FactoryGirl.create(:account) }

  it "sets an auth token" do
    expect(account.auth_token).not_to be_blank
  end

  it "requires a secure password when invited" do
    FactoryGirl.create(:team_member_invite, invitee_email: "test@account.com")
    account = FactoryGirl.build(:account, email: "test@account.com", password: "short")
    expect(account).not_to be_valid
    expect(account.errors[:password]).to eq(["is too short (minimum is 8 characters)"])
  end

  %i{mentor regional_ambassador}.each do |type|
    it "doesn't need a BG check outside of the US" do
      account = FactoryGirl.create(type,
                                   city: "Salvador",
                                   state_province: "Bahia",
                                   country: "BR")
      expect(account).to be_background_check_complete
    end
  end

  it "calculates age" do
    account.date_of_birth = 15.years.ago + 1.day
    expect(account.age).to eq(14)

    account.date_of_birth = 15.years.ago
    expect(account.age).to eq(15)
  end

  it "calculates age compared to a particular date" do
    account.date_of_birth = 15.years.ago + 3.months
    expect(account.age(3.months.from_now)).to eq(15)
  end

  it "does a somewhat normal email validation" do
    account.skip_existing_password = true

    account.email = "hello@world.com"
    account.valid?
    expect(account.errors.keys).not_to include(:email)

    account.email = "hellono"
    account.valid?
    expect(account.errors.keys).to include(:email)

    account.email = "hello@world.com, hello@someone.com"
    account.valid?
    expect(account.errors.keys).to include(:email)
  end

  it "re-cache team_region_division_names as account gets added to new teams" do
    account = FactoryGirl.create(:mentor).account
    expect(account.team_region_division_names).to be_empty

    account.teams << FactoryGirl.create(:team)
    expect(account.team_region_division_names).to match_array(["US_IL,senior"])

    account.teams << FactoryGirl.create(
      :team,
      city: "Los Angeles",
      state_province: "CA"
    )
    expect(account.team_region_division_names).to match_array(
      ["US_IL,senior",
       "US_CA,senior"]
    )
  end

  it "geocodes when address info changes" do
    a = FactoryGirl.create(:account) # Chicago by default

    # Sanity
    expect(a.latitude).to eq(41.50196838)
    expect(a.longitude).to eq(-87.64051818)

    a.city = "Los Angeles"
    a.state_province = "CA"
    a.valid?

    expect(a.latitude).to eq(34.052363)
    expect(a.longitude).to eq(-118.256551)
  end

  it "reverse geocodes when coords change" do
    a = FactoryGirl.create(:account, city: "Los Angeles", state_province: "CA")

    # Sanity
    expect(a.city).to eq("Los Angeles")
    expect(a.state_province).to eq("CA")
    expect(a.latitude).to eq(34.052363)
    expect(a.longitude).to eq(-118.256551)

    a.latitude = 41.50196838
    a.longitude = -87.64051818
    a.valid?

    expect(a.city).to eq("Chicago")
    expect(a.state_province).to eq("IL")
  end
end
