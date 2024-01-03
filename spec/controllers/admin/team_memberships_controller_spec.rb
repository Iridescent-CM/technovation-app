require "rails_helper"

RSpec.describe Admin::TeamMembershipsController do
  let(:team) { FactoryBot.create(:team) }

  before do
    admin = FactoryBot.create(:admin)
    sign_in(admin)
  end

  describe "POST #create" do
    it "can add mentors" do
      mentor = FactoryBot.create(:mentor, :onboarded)

      post :create, params: {
        team_id: team.id,
        account_id: mentor.account_id
      }

      expect(team.reload.mentors).to eq([mentor])
    end

    it "can add students" do
      student = FactoryBot.create(:student)

      post :create, params: {
        team_id: team.id,
        account_id: student.account_id
      }

      expect(team.reload.students).to include(student)
    end
  end
end
