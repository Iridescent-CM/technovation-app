require "rails_helper"

RSpec.describe ConsentWaiversController do
  describe "POST #create" do
    it "preserves the token on a validation error" do
      mentor = FactoryGirl.create(:mentor)
      post :create, consent_waiver: { account_consent_token: mentor.consent_token }
      expect(assigns[:consent_waiver].account_consent_token).to eq(mentor.consent_token)
    end
  end

  describe "GET #new" do
    it "assigns the account to the consent" do
      regional_ambassador = FactoryGirl.create(:regional_ambassador)
      get :new, token: regional_ambassador.consent_token
      expect(assigns[:consent_waiver].account_consent_token).to eq(regional_ambassador.consent_token)
    end
  end
end
