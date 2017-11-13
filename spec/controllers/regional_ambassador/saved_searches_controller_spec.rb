require "rails_helper"

RSpec.describe RegionalAmbassador::SavedSearchesController do
  describe "POST #create" do
    it "renders the saved search partial, even from json" do
      ra = FactoryBot.create(:ambassador)
      sign_in(ra)

      post :create, params: {
        saved_search: {
          name: "my savey searchey",
          param_root: "accounts_grid",
          search_string: "parameterized-query",
        }
      }, format: :json

      expect(response).to render_template(
        partial: "saved_searches/_saved_search",
      )
    end
  end
end
