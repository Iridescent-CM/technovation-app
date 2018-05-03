require "rails_helper"

RSpec.describe Judge::AssignedSubmissionsController do
  describe "GET #index" do
    it "works nice for virtual judges" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team, :submitted)
      event = FactoryBot.create(:event)

      create_event_assignment(event: event, teams: team, judges: judge)
      CreateJudgeAssignment.(team: team, judge: judge)

      sign_in(judge)
      get :index
    end
  end

  private
  def create_event_assignment(event:, teams: [], judges: [])
    CreateEventAssignment.(event, ActionController::Parameters.new({
      invites: BuildKludgyVueParams.(teams, judges),
    }))
  end
end