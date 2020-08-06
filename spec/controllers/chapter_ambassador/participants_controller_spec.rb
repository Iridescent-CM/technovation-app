require "rails_helper"

RSpec.describe ChapterAmbassador::ParticipantsController do
  describe "GET #index" do
    it "is okay with empty params" do
      chapter_ambassador = FactoryBot.create(:ambassador)
      sign_in(chapter_ambassador)

      expect {
        get :index
      }.not_to raise_error
    end

    it "hoists legacy params" do
      chapter_ambassador = FactoryBot.create(:ambassador)
      sign_in(chapter_ambassador)

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
        season: Season.current.year,
        season_and_or: "match_any",
        column_names: ["city"],
      }).permit(
        :name_email,
        :admin,
        :allow_state_search,
        :season,
        :season_and_or,
        country: [],
        state_province: [],
        column_names: [],
      )

      expect(AccountsGrid).to have_received(:new).with(params)
    end

    it "leaves new params alone, deleting legacy params" do
      chapter_ambassador = FactoryBot.create(:ambassador)
      sign_in(chapter_ambassador)

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
