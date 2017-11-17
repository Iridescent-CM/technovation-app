require "rails_helper"

RSpec.describe Account do
  subject(:account) { FactoryBot.create(:account) }

  it "sets an auth token" do
    expect(account.auth_token).not_to be_blank
  end

  it "returns a NullTeams for accounts that can't be on teams" do
    %w{judge regional_ambassador}.each do |type|
      profile = FactoryBot.create(type)
      expect(profile.account.teams.current).to eq(Team.none)
    end
  end

  it "requires a secure password when invited" do
    FactoryBot.create(:team_member_invite, invitee_email: "test@account.com")
    account = FactoryBot.build(
      :account,
      email: "test@account.com",
      password: "short"
    )
    expect(account).not_to be_valid
    expect(account.errors[:password]).to eq([
      "is too short (minimum is 8 characters)"
    ])
  end

  %i{mentor regional_ambassador}.each do |type|
    it "doesn't need a BG check outside of the US" do
      account = FactoryBot.create(type,
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

  it "does not require a password for email case changing" do
    account = FactoryBot.build(:account, email: "caSE@change.COM")
    account.save(validate: false)

    account.reload

    expect(account.save).to be true
    expect(account.reload.email).to eq("case@change.com")
  end

  it "re-cache team_region_division_names as account gets added to new teams" do
    account = FactoryBot.create(:mentor).account
    expect(account.team_region_division_names).to be_empty

    account.teams << FactoryBot.create(:team)
    expect(account.team_region_division_names).to match_array(["US_IL,junior"])

    account.teams << FactoryBot.create(
      :team,
      city: "Los Angeles",
      state_province: "CA"
    )
    expect(account.team_region_division_names).to match_array(
      ["US_IL,junior",
       "US_CA,junior"]
    )
  end

  describe ".inactive_mentors" do
    it "pulls mentors with no new activities since 3 weeks ago" do
      active = FactoryBot.create(:mentor)
      inactive = FactoryBot.create(:mentor)

      active.activities.destroy_all
      inactive.activities.destroy_all

      active.account.create_activity({
        key: "account.update"
      })

      inactive.account.create_activity({
        key: "account.update",
        created_at: 22.days.ago
      })

      expect(Account.inactive_mentors).to eq([inactive.account])
    end
  end
end
