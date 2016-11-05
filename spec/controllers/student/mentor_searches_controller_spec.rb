require "rails_helper"

RSpec.describe Student::MentorSearchesController do
  describe "GET #new" do
    it "displays nearby mentors" do
      mentor = FactoryGirl.create(:mentor, :with_expertises)
      student = FactoryGirl.create(:student, :on_team)

      sign_in(student)

      get :new

      expect(assigns[:mentors]).to eq([mentor])
    end

    it "does not display unsearchable mentors" do
      mentor = FactoryGirl.create(:mentor, :with_expertises)
      student = FactoryGirl.create(:student, :on_team)

      mentor.background_check.destroy

      sign_in(student)

      get :new

      expect(assigns[:mentors]).to be_empty
    end

    it "filters mentors who are in-person only" do
      FactoryGirl.create(
        :mentor,
        virtual: false,
        geocoded: "Los Angeles, CA",
      )

      sign_in(FactoryGirl.create(:student, :on_team, geocoded: "Chicago, IL"))

      get :new, nearby: "anywhere", virtual_only: 1

      expect(assigns[:mentors]).to be_empty
    end
  end
end
