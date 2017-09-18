require "rails_helper"

RSpec.describe Admin::TeamMembershipsController do
  let(:team) { FactoryGirl.create(:team) }

  before do
    admin = FactoryGirl.create(:admin)
    sign_in(admin)
  end

  describe "POST #create" do
    it "can add mentors" do
      mentor = FactoryGirl.create(:mentor)

      post :create, params: {
        team_id: team.id,
        account_id: mentor.account_id,
      }

      expect(team.reload.mentors).to eq([mentor])
    end

    it "can add students" do
      student = FactoryGirl.create(:student)

      post :create, params: {
        team_id: team.id,
        account_id: student.account_id,
      }

      expect(team.reload.students).to include(student)
    end
  end
end
