require "rails_helper"

RSpec.describe Team do
  it "deals okay with funky region name input" do
    team = FactoryGirl.create(:team)

    allow(team.creator.account).to receive(:state_province) { " NY " }

    expect { team.region_name }.not_to raise_error
  end

  it "fixes funky brasil/brazil region issue" do
    team = FactoryGirl.create(:team)

    allow(team.creator.account).to receive(:state_province) { "Brasil" }
    expect(team.region_name).to eq("Brazil")

    allow(team.creator.account).to receive(:state_province) { "Brazil" }
    expect(team.region_name).to eq("Brazil")
  end

  it "assigns to the B division if all students are in Division B" do
    team = FactoryGirl.create(:team)
    younger_student = FactoryGirl.create(:student, date_of_birth: 13.years.ago)
    older_student = FactoryGirl.create(:student, date_of_birth: 14.years.ago)

    team.add_student(older_student)
    team.add_student(younger_student)

    expect(team.division).to eq(Division.senior)
  end

  it "assigns to the correct division if a student updates their birthdate" do
    team = FactoryGirl.create(:team, members_count: 0)
    younger_student = FactoryGirl.create(:student, date_of_birth: 13.years.ago)
    older_student = FactoryGirl.create(:student, date_of_birth: 14.years.ago)

    team.add_student(older_student)
    team.add_student(younger_student)

    older_student.account.update_attributes(date_of_birth: 13.years.ago)

    expect(team.reload.division).to eq(Division.junior)
  end

  it "reconsiders division when a student leaves the team" do
    team = FactoryGirl.create(:team, members_count: 0)
    younger_student = FactoryGirl.create(:student, date_of_birth: 13.years.ago)
    older_student = FactoryGirl.create(:student, date_of_birth: 14.years.ago)

    team.add_student(older_student)
    team.add_student(younger_student)
    team.remove_student(older_student)

    expect(team.reload.division).to eq(Division.junior)
  end

  it "scopes to past seasons" do
    FactoryGirl.create(:team) # current season by default

    past_date = if Season.switch_date.year === Time.current.year
                  Season.switch_date - 367.days
                else
                  Season.switch_date - 1.day
                end

    past_team = FactoryGirl.create(:team, created_at: past_date)

    expect(Team.past).to eq([past_team])
  end

  it "scopes to the current season" do
    current_team = FactoryGirl.create(:team) # current season by default

    past_date = if Season.switch_date.year === Time.current.year
                  Season.switch_date - 367.days
                else
                  Season.switch_date - 1.day
                end

    FactoryGirl.create(:team, created_at: past_date)
    expect(Team.current).to eq([current_team])
  end

  it "excludes current season teams from the past scope" do
    current_team = FactoryGirl.create(:team) # current season by default

    past_date = if Season.switch_date.year === Time.current.year
                  Season.switch_date - 367.days
                else
                  Season.switch_date - 1.day
                end

    past_team = FactoryGirl.create(:team, created_at: past_date)

    SeasonRegistration.register(current_team, past_team.seasons.last)

    expect(Team.past).not_to include(current_team)
  end

  it "has a no mentor scope" do
    team = FactoryGirl.create(:team)
    FactoryGirl.create(:team, :with_mentor)
    expect(Team.without_mentor).to eq([team])
  end

  it "registers to past seasons" do
    team = FactoryGirl.create(:team, created_at: Time.new(2015, 8, 1, 0, 0, 0, "-08:00"))
    expect(team.seasons.map(&:year)).to eq([2016])
  end

  describe ".region_division_name" do
    it "includes state in US" do
      team = FactoryGirl.create(:team)
      expect(team.region_division_name).to eq("US_IL,senior")
    end

    it "uses only country outside the US" do
      team = FactoryGirl.create(:team, creator_in: "Salvador", creator_country: "BR")
      expect(team.region_division_name).to eq("BR,senior")
    end

    it "won't blow up without country" do
      team = FactoryGirl.create(:team, creator_in: nil, creator_country: nil)
      expect(team.region_division_name).to eq(",senior")
    end

    it "should re-cache if creator details change" do
      team = FactoryGirl.create(:team)
      expect(team.region_division_name).to eq("US_IL,senior")
      team.creator.date_of_birth = Date.today - 10.years
      team.creator.save
      expect(team.reload.region_division_name).to eq("US_IL,junior")
    end

    it "should re-cache if members change" do
      team = FactoryGirl.create(:team)
      expect(team.region_division_name).to eq("US_IL,senior")
      team.remove_student(team.students.first)
      expect(team.reload.region_division_name).to eq(",none_assigned_yet")
    end
  end
end
