require "rails_helper"

RSpec.describe Judge::DashboardsController do
  describe "GET #show" do
    context "when signed in as a judge with a mentor profile on a team" do
      it "redirects to the mentor dashboard" do
        judge_with_mentor_profile = FactoryBot.create(:mentor, :on_team, :has_judge_profile)
        sign_in(judge_with_mentor_profile)
        get :show
        expect(response).to redirect_to(mentor_dashboard_path)
      end
    end
  end
end
