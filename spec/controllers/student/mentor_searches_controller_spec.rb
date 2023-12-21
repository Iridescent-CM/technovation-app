require "rails_helper"

RSpec.describe Student::MentorSearchesController do
  describe "GET #new" do
    it "displays nearby mentors" do
      mentor = FactoryBot.create(:mentor, :onboarded, :geocoded, :with_expertises)
      student = FactoryBot.create(:student, :geocoded, :on_team)

      sign_in(student)

      get :new

      expect(assigns[:mentors]).to eq([mentor])
    end

    it "does not display unsearchable mentors" do
      mentor = FactoryBot.create(:mentor, :onboarded, :geocoded, :with_expertises)
      student = FactoryBot.create(:student, :geocoded, :on_team)

      mentor.account.reload
      mentor.background_check.destroy

      sign_in(student)

      get :new

      expect(assigns[:mentors]).to be_empty
    end

    it "filters mentors who are in-person only" do
      FactoryBot.create(
        :mentor,
        :geocoded,
        virtual: false,
        city: "Los Angeles",
        state_province: "CA"
      )

      sign_in(FactoryBot.create(:student, :geocoded, :on_team))

      get :new, params: {nearby: "anywhere", virtual_only: 1}

      expect(assigns[:mentors]).to be_empty
    end
  end
end
