require "rails_helper"

RSpec.describe Admin::EventTeamsController do
  let(:admin) { FactoryBot.create(:admin) }
  let(:event) { FactoryBot.create(:rpe, :senior) }
  let(:submission) { FactoryBot.create(:team_submission, :senior, :complete) }
  let(:team) { submission.team }

  before { sign_in(admin) }

  describe "POST #create" do
    it "adds an eligible team to the event and redirects" do
      expect {
        post :create, params: {event_id: event.id, team_id: team.id}
      }.to change { event.reload.teams.count }.by(1)

      expect(event.reload.teams).to include(team)
      expect(response).to redirect_to(admin_event_path(event))
    end

    it "adds the team even when the add-teams season toggle is off" do
      allow(SeasonToggles)
        .to receive(:add_teams_to_regional_pitch_event?)
        .and_return(false)

      expect {
        post :create, params: {event_id: event.id, team_id: team.id}
      }.to change { event.reload.teams.count }.by(1)
    end
  end

  describe "DELETE #destroy" do
    it "removes the team from the event and redirects" do
      event.teams << team

      expect {
        delete :destroy, params: {event_id: event.id, id: team.id}
      }.to change { event.reload.teams.count }.by(-1)

      expect(event.reload.teams).not_to include(team)
      expect(response).to redirect_to(admin_event_path(event))
    end
  end
end
