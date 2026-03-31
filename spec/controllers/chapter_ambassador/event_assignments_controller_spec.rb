require "rails_helper"

RSpec.describe ChapterAmbassador::EventAssignmentsController do
  describe "POST #create" do
    it "allows the same judge in more than one event" do
      judge = FactoryBot.create(:judge)

      team1 = FactoryBot.create(:team, :submitted)
      team2 = FactoryBot.create(:team, :submitted)

      chapter_ambassador = FactoryBot.create(:chapter_ambassador)
      event1 = FactoryBot.create(:event, ambassador: chapter_ambassador)
      event2 = FactoryBot.create(:event, ambassador: chapter_ambassador)

      sign_in(chapter_ambassador)

      expect {
        post_create(
          invites: {
            teams: [team1, team2],
            judges: judge
          },
          event: event1
        )

        post_create(
          invites: {
            judges: judge
          },
          event: event2
        )
      }
        .to change { event1.teams.count }.by(2)
        .and change { event1.judges.count }.by(1)
        .and change { event2.judges.count }.by(1)
        .and change { judge.events.count }.by(2)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the judge's team assignments in the event" do
      judge = FactoryBot.create(:judge)
      team = FactoryBot.create(:team, :submitted)
      chapter_ambassador = FactoryBot.create(:chapter_ambassador)
      event = FactoryBot.create(:event, ambassador: chapter_ambassador)

      event.teams << team
      event.judges << judge
      judge.assigned_teams << team

      sign_in(chapter_ambassador)
      expect {
        delete :destroy, params: {
          event_assignment: {
            event_id: event.id,
            attendee_id: judge.id,
            attendee_scope: "JudgeProfile"
          }
        }
      }.to change { judge.assigned_teams.count }.by(-1)
    end
  end

  private

  def post_create(event:, invites: {})
    post :create, params: {
      event_assignment: {
        invites: BuildKludgyVueParams.call(invites[:teams], invites[:judges]),
        event_id: event.id
      }
    }
  end
end
