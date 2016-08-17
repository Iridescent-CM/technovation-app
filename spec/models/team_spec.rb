require "rails_helper"

RSpec.describe Team do
  it "assigns to the B division if all students are in Division B" do
    team = FactoryGirl.create(:team)
    younger_student = FactoryGirl.create(:student, date_of_birth: 13.years.ago)
    older_student = FactoryGirl.create(:student, date_of_birth: 14.years.ago)

    team.add_student(older_student)
    team.add_student(younger_student)

    expect(team.division).to eq(Division.a)
  end

  it "scopes to past seasons" do
    FactoryGirl.create(:team) # current season by default
    past_team = FactoryGirl.create(:team, created_at: Season.switch_date - 1.day)
    expect(Team.past).to eq([past_team])
  end

  it "scopes to the current season" do
    current_team = FactoryGirl.create(:team) # current season by default
    FactoryGirl.create(:team, created_at: Season.switch_date - 1.day)
    expect(Team.current).to eq([current_team])
  end

  it "excludes current season teams from the past scope" do
    current_team = FactoryGirl.create(:team) # current season by default
    past_team = FactoryGirl.create(:team, created_at: Season.switch_date - 1.day)

    SeasonRegistration.register(current_team, past_team.seasons.last)

    expect(Team.past).not_to include(current_team)
  end
end
