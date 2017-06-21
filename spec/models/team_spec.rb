require "rails_helper"

RSpec.describe Team do
  it "deals okay with funky region name input" do
    team = FactoryGirl.create(:team)

    allow(team).to receive(:state_province) { " NY " }

    expect { team.region_name }.not_to raise_error
  end

  it "fixes funky brasil/brazil region issue" do
    team = FactoryGirl.create(:team)

    allow(team).to receive(:state_province) { "Brasil" }
    expect(team.region_name).to eq("Brazil")

    allow(team).to receive(:state_province) { "Brazil" }
    expect(team.region_name).to eq("Brazil")
  end

  it "assigns to the B division if all students are in Division B" do
    team = FactoryGirl.create(:team)
    younger_student = FactoryGirl.create(:student, date_of_birth: 13.years.ago)
    older_student = FactoryGirl.create(:student, date_of_birth: 14.years.ago)

    TeamRosterManaging.add(team, [older_student, younger_student])

    expect(team.division).to eq(Division.senior)
  end

  it "assigns to the correct division if a student updates their birthdate" do
    team = FactoryGirl.create(:team, members_count: 0)
    younger_student = FactoryGirl.create(:student, date_of_birth: 13.years.ago)
    older_student = FactoryGirl.create(:student, date_of_birth: 14.years.ago)

    TeamRosterManaging.add(team, [older_student, younger_student])

    ProfileUpdating.execute(older_student, {
      account_attributes: {
        id: older_student.account_id,
        date_of_birth: 13.years.ago,
      },
    })

    expect(team.reload.division).to eq(Division.junior)
  end

  it "reconsiders division when a student leaves the team" do
    team = FactoryGirl.create(:team, members_count: 0)
    younger_student = FactoryGirl.create(:student, date_of_birth: 13.years.ago)
    older_student = FactoryGirl.create(:student, date_of_birth: 15.years.ago)

    TeamRosterManaging.add(team, [older_student, younger_student])
    expect(team.reload.division).to eq(Division.senior)

    TeamRosterManaging.remove(team, older_student)
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
    team = FactoryGirl.create(
      :team,
      created_at: Time.new(2015, 8, 1, 0, 0, 0, "-08:00")
    )
    expect(team.seasons.map(&:year)).to eq([2016])
  end

  describe ".region_division_name" do
    it "includes state in US" do
      team = FactoryGirl.create(:team)
      expect(team.region_division_name).to eq("US_IL,senior")
    end

    it "uses only country outside the US" do
      team = FactoryGirl.create(:team,
                                city: "Salvador",
                                state_province: "Bahia",
                                country: "BR")
      expect(team.region_division_name).to eq("BR,senior")
    end

    it "won't blow up without country" do
      team = FactoryGirl.create(
        :team,
        city: nil,
        state_province: nil,
        country: nil
      )
      expect(team.region_division_name).to eq(",senior")
    end

    it "should re-cache if member details change" do
      team = FactoryGirl.create(:team)
      expect(team.region_division_name).to eq("US_IL,senior")

      member = team.members.sample
      profile_updating = ProfileUpdating.new(member)
      profile_updating.update({
        account_attributes: {
          id: member.account_id,
          date_of_birth: Date.today - 10.years,
        },
      })

      expect(team.reload.region_division_name).to eq("US_IL,junior")
    end

    it "should re-cache if membership changes" do
      team = FactoryGirl.create(:team)
      expect(team.region_division_name).to eq("US_IL,senior")

      team.memberships.each(&:destroy)
      expect(team.reload.region_division_name).to eq("US_IL,none_assigned_yet")
    end
  end

  it "geocodes when address info changes" do
    team = FactoryGirl.create(:team, :geocoded) # Chicago by default

    # Sanity
    expect(team.latitude).to eq(41.50196838)
    expect(team.longitude).to eq(-87.64051818)

    TeamUpdating.execute(team, {
      city: "Los Angeles",
      state_province: "CA",
    })

    team.reload
    expect(team.latitude).to eq(34.052363)
    expect(team.longitude).to eq(-118.256551)
  end

  it "reverse geocodes when coords change" do
    team = FactoryGirl.create(
      :team,
      :geocoded,
      city: "Los Angeles",
      state_province: "CA"
    )

    # Sanity
    expect(team.city).to eq("Los Angeles")
    expect(team.state_province).to eq("CA")
    expect(team.latitude).to eq(34.052363)
    expect(team.longitude).to eq(-118.256551)

    TeamUpdating.execute(team, {
      latitude: 41.50196838,
      longitude: -87.64051818,
    })

    team.reload
    expect(team.city).to eq("Chicago")
    expect(team.state_province).to eq("IL")
  end

  it "removes associated RPEs when address info changes" do
    team = FactoryGirl.create(:team)
    rpe = FactoryGirl.create(:rpe)

    # Sanity
    team.regional_pitch_events << rpe
    expect(team.reload.selected_regional_pitch_event).to eq(rpe)

    TeamUpdating.execute(team, {
      city: "Los Angeles",
      state_province: "CA",
    })

    team.reload
    expect(team.regional_pitch_events).to be_empty

    # Sanity
    team.regional_pitch_events << rpe
    expect(team.reload.selected_regional_pitch_event).to eq(rpe)

    TeamUpdating.execute(team, {
      city: "Salvador",
      state_province: "Bahia",
      country: "BR",
    })

    team.reload
    expect(team.regional_pitch_events).to be_empty
  end

  it "touches its submission when division changes" do
    team = FactoryGirl.create(:team, members_count: 0)
    submission = FactoryGirl.create(:submission, team: team)

    old_student = FactoryGirl.create(:student, date_of_birth: 15.years.ago)
    young_student = FactoryGirl.create(:student, date_of_birth: 14.years.ago)

    TeamRosterManaging.add(team, [old_student, young_student])
    expect(team).to be_senior

    submission_updated = submission.updated_at

    TeamRosterManaging.remove(team, old_student)
    expect(team.reload).to be_junior

    expect(submission_updated).to be < submission.reload.updated_at
  end
end
