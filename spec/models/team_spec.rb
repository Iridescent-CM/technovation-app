require "rails_helper"

RSpec.describe Team do
  before { Timecop.travel(Division.cutoff_date - 1.day) }
  after { Timecop.return }

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
    older_student = FactoryGirl.create(
      :student,
      date_of_birth: Division.cutoff_date - 15.years
    )

    TeamRosterManaging.add(team, [older_student, younger_student])

    expect(team.division).to eq(Division.senior)
  end

  it "assigns to the correct division if a student updates their birthdate" do
    team = FactoryGirl.create(:team)
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
    team = FactoryGirl.create(:team)
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

    current_team.update(seasons: (current_team.seasons << past_team.seasons.last))

    expect(Team.past).not_to include(current_team)
  end

  it "registers to past seasons" do
    team = FactoryGirl.create(
      :team,
      created_at: Time.new(
        2015,
        Season.switch_month,
        Season.switch_day,
        0,
        0,
        0,
        "-08:00"
      )
    )
    expect(team.reload.seasons).to eq([2016])
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
    team = FactoryGirl.create(:team)
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

  it "validates unique names only on undeleted teams" do
    fring = FactoryGirl.create(:team, name: "Say My Name")
    fring.destroy

    heisenberg = FactoryGirl.create(:team, name: "Say My Name")
    expect(heisenberg).to be_valid
    expect(heisenberg.reload.id).not_to be_nil
  end

  it "deletes itself and pending join requests/invites when membership decrements to zero" do
    team = FactoryGirl.create(:team)

    team.team_member_invites.create!(
      invitee_email: "will@delete.com",
      inviter: FactoryGirl.create(:mentor),
    )

    team.join_requests.create!(
      requestor: FactoryGirl.create(:student),
    )

    team.members.each do |m|
      TeamRosterManaging.remove(team, m)
    end

    expect(team).to be_deleted
    expect(team.team_member_invites).to be_empty
    expect(team.join_requests).to be_empty
  end

  describe ".unmatched(scope)" do
    it "lists teams without a mentor" do
      mentored = FactoryGirl.create(:team)
      mentor = FactoryGirl.create(:mentor)
      TeamRosterManaging.add(mentored, mentor)

      unmatched = FactoryGirl.create(:team)
      expect(Team.unmatched(:mentors)).to eq([unmatched])
    end

    it "lists teams without students" do
      FactoryGirl.create(:team)

      unmatched = FactoryGirl.create(:team)
      mentor = FactoryGirl.create(:mentor)
      TeamRosterManaging.add(unmatched, mentor)
      TeamRosterManaging.remove(unmatched, unmatched.students.first)

      expect(Team.unmatched(:students)).to eq([unmatched])
    end

    it "only considers current teams" do
      past_unmatched = FactoryGirl.create(:team)
      past_unmatched.update(seasons: [Season.current.year - 1])

      unmatched = FactoryGirl.create(:team)

      expect(Team.unmatched(:mentors)).to eq([unmatched])
    end
  end

  describe ".in_region" do
    it "scopes to the given US ambassador's state" do
      FactoryGirl.create(
        :team,
        city: "Los Angeles",
        state_province: "CA",
        country: "US"
      )

      il_team = FactoryGirl.create(:team)
      il_ambassador = FactoryGirl.create(:ambassador)

      expect(
        Team.in_region(il_ambassador)
      ).to eq([il_team])
    end

    it "scopes to the given Int'l ambassador's country" do
      FactoryGirl.create(:team)

      intl_team = FactoryGirl.create(
        :team,
        city: "Salvador",
        state_province: "Bahia",
        country: "Brazil"
      )

      intl_ambassador = FactoryGirl.create(
        :ambassador,
        city: "Salvador",
        state_province: "Bahia",
        country: "Brazil"
      )

      expect(
        Team.in_region(intl_ambassador)
      ).to eq([intl_team])
    end
  end
end
