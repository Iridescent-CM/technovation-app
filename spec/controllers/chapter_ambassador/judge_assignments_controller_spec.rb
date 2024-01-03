require "rails_helper"

RSpec.describe ChapterAmbassador::JudgeAssignmentsController do
  describe "POST #create" do
    it "allows the same judge in more than one event" do
      judge = FactoryBot.create(:judge)

      team1 = FactoryBot.create(:team, :submitted)
      team2 = FactoryBot.create(:team, :submitted)
      team3 = FactoryBot.create(:team, :submitted)

      chapter_ambassador = FactoryBot.create(:chapter_ambassador)
      event1 = FactoryBot.create(:event, ambassador: chapter_ambassador)
      event2 = FactoryBot.create(:event, ambassador: chapter_ambassador)

      sign_in(chapter_ambassador)

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
          model_scope: "JudgeProfile"
        }
      }

      teams = GatherAssignedTeams.call(judge)
      expect(teams).to contain_exactly(team1, team3)
    end
  end

  describe "DELETE #destroy" do
    it "clears out unassigned scores" do
      judge = FactoryBot.create(:judge)

      team1 = FactoryBot.create(:team, :submitted)
      team2 = FactoryBot.create(:team, :submitted)
      team3 = FactoryBot.create(:team, :submitted)

      chapter_ambassador = FactoryBot.create(:chapter_ambassador)
      event1 = FactoryBot.create(:event, ambassador: chapter_ambassador)
      event2 = FactoryBot.create(:event, ambassador: chapter_ambassador)

      sign_in(chapter_ambassador)

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

      SeasonToggles.set_judging_round(:qf)

      post :create, params: {
        judge_assignment: {
          judge_id: judge.id,
          team_id: team1.id,
          model_scope: "JudgeProfile"
        }
      }

      teams = GatherAssignedTeams.call(judge)
      expect(teams).to contain_exactly(team1, team3)

      score = SubmissionScore.create!(
        judge_profile: judge,
        team_submission: team1.submission
      )

      delete :destroy, params: {
        judge_assignment: {
          judge_id: judge.id,
          team_id: team1.id,
          model_scope: "JudgeProfile"
        }
      }

      expect(score.reload).to be_deleted
      expect(judge.submission_scores).to be_empty

      teams = GatherAssignedTeams.call(judge)
      expect(teams.map(&:id)).to contain_exactly(team1.id, team2.id, team3.id)

      SeasonToggles.set_judging_round(:off)
    end
  end

  private

  def create_event_assignment(event:, teams: [], judges: [])
    CreateEventAssignment.call(event, ActionController::Parameters.new({
      invites: BuildKludgyVueParams.call(teams, judges)
    }))
  end
end
