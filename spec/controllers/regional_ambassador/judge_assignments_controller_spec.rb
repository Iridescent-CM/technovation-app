require "rails_helper"

RSpec.describe RegionalAmbassador::JudgeAssignmentsController do
  describe "POST #create" do
    it "allows the same judge in more than one event" do
      judge = FactoryBot.create(:judge)

      team1 = FactoryBot.create(:team, :submitted)
      team2 = FactoryBot.create(:team, :submitted)
      team3 = FactoryBot.create(:team, :submitted)

      ra = FactoryBot.create(:ra)
      event1 = FactoryBot.create(:event, ambassador: ra)
      event2 = FactoryBot.create(:event, ambassador: ra)

      sign_in(ra)

      create_event_assignment(
        event: event1,
        teams: [team1, team2],
        judges: judge
      )

      create_event_assignment(
        event: event2,
        teams: team3,
        judges: judge
      )

      post :create, params: {
        judge_assignment: {
          judge_id: judge.id,
          team_id: team1.id,
          model_scope: "JudgeProfile",
        },
      }

      teams = GatherAssignedTeams.(judge)
      expect(teams).to contain_exactly(team1, team3)
    end
  end

  private
  def create_event_assignment(event:, teams: [], judges: [])
    CreateEventAssignment.(event, ActionController::Parameters.new({
      invites: BuildKludgyVueParams.(teams, judges),
    }))
  end
end