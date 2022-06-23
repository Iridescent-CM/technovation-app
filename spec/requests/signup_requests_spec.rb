require "rails_helper"

RSpec.describe "Signing up", type: :request do
  context "when registration is closed" do
    before do
      SeasonToggles.disable_signups!
    end

    it "redirects to the homepage" do
      get "/signup"

      expect(response).to redirect_to("/")
    end
  end
end
