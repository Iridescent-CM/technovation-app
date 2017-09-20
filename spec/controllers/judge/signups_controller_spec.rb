require "rails_helper"

RSpec.describe Judge::SignupsController do
  before do
    set_signup_token({
      email: "invited@thanks.com",
      password: "secret1234",
    })
  end

  describe "POST #create" do
    before do
      post :create, params: {
        judge_profile: FactoryGirl.attributes_for(:judge).merge(
          account_attributes: FactoryGirl.attributes_for(:account)
        )
      }
    end

    it "redirects to the judge dashboard" do
      expect(response).to redirect_to(judge_dashboard_path)
      expect(flash[:success]).to eq("Welcome to Technovation!")
    end

    it "registers the judge to the current season" do
      expect(Account.last.seasons).to eq([Season.current.year])
    end
  end
end
