require "rails_helper"

RSpec.describe RegionalAmbassador::JudgeSearchesController do
  describe "GET #show" do
    it "adds user invitation search results when no other matches" do
      joe = UserInvitation.create!(
        name: "joe",
        email: "joe@joesak.com",
        profile_type: :judge,
      )

      UserInvitation.create!(
        name: "trav",
        email: "trav@gmail.com",
        profile_type: :student,
      )

      sign_in(:ra)

      get :show, params: { name: "", email: "" }

      json = JSON.parse(response.body)
      expect(json.length).to be 1
      expect(json.last["id"]).to eq(joe.id)

      # new email does not add them - fixing bug
      get :show, params: { name: "", email: "new@email.com" }

      json = JSON.parse(response.body)
      expect(json).to be_empty
    end
  end
end
