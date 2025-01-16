require "rails_helper"

RSpec.describe ClubAmbassador::SavedSearchesController do
  describe "POST #create" do
    it "renders the saved search partial, when posting in json format" do
      club_ambassador = FactoryBot.create(:club_ambassador)
      sign_in(club_ambassador)

      post :create, params: {
        saved_search: {
          name: "my savey searchey",
          param_root: "accounts_grid",
          search_string: "parameterized-query"
        }
      }, format: :json

      expect(response).to render_template(
        partial: "saved_searches/_saved_search"
      )
    end
  end
end
