require "rails_helper"

RSpec.describe RegionalAmbassador::ParticipantsController do
  describe "GET #index" do
    it "is okay with empty params" do
      ra = FactoryBot.create(:ambassador)
      sign_in(ra)

      expect {
        get :index
      }.not_to raise_error
    end

    it "hoists legacy params" do
      ra = FactoryBot.create(:ambassador)
      sign_in(ra)

      allow(AccountsGrid).to receive(:new)

      get :index, params: {
        accounts_grid: {
          name: "hello",
          email: "email",
        },
      }

      params = ActionController::Parameters.new({
        name_email: "hello email",
        admin: false,
        allow_state_search: false,
        country: ["US"],
        state_province: ["IL"],
        season: 2018,
        column_names: ["city"],
      }).permit(
        :name_email,
        :admin,
        :allow_state_search,
        :season,
        country: [],
        state_province: [],
        column_names: [],
      )

      expect(AccountsGrid).to have_received(:new).with(params)
    end

    it "leaves new params alone, deleting legacy params" do
      ra = FactoryBot.create(:ambassador)
      sign_in(ra)

      allow(AccountsGrid).to receive(:new)

      get :index, params: {
        accounts_grid: {
          name_email: "hello",
          name: "blargh i am deleted",
          email: "blargh i am also deleted",
        },
      }

      expect(AccountsGrid).to have_received(:new).with(
        hash_including(name_email: "hello")
      )

      expect(AccountsGrid).to have_received(:new).with(
        hash_excluding({
          name: "blargh i am deleted",
          email: "blargh i am also deleted",
        })
      )
    end
  end
end
