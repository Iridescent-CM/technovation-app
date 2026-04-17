require "rails_helper"

RSpec.describe Admin::EventTeamsController do
  let(:admin) { FactoryBot.create(:admin) }
  let(:event) { FactoryBot.create(:regional_pitch_event) }

  before { sign_in(admin) }

  describe "POST #create" do
    it "adds a team to the event" do
      team = FactoryBot.create(:team, :junior, :live_event_eligible)

      expect {
        post :create, params: { event_id: event.id, team_id: team.id }
      }.to change { event.reload.teams.count }.by(1)
    end
  end

  describe "DELETE #destroy" do
    it "removes a team from the event" do
      team = FactoryBot.create(:team, :junior, :live_event_eligible)
      event.teams << team

      expect {
        delete :destroy, params: { event_id: event.id, id: team.id }
      }.to change { event.reload.teams.count }.by(-1)
    end
  end

  context "when add_teams_to_regional_pitch_event is disabled" do
    before do
      allow(SeasonToggles).to receive(:add_teams_to_regional_pitch_event?).and_return(false)
    end

    it "still adds a team to the event" do
      team = FactoryBot.create(:team, :junior, :live_event_eligible)

      expect {
        post :create, params: { event_id: event.id, team_id: team.id }
      }.to change { event.reload.teams.count }.by(1)
    end
  end
end
