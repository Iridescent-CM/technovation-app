require "rails_helper"

RSpec.describe "A mentor requesting to join a student's team", :js do
  before { SeasonToggles.team_building_enabled = "yes" }

  let(:student) { FactoryBot.create(:student, :geocoded, :on_team) }
  let!(:mentor) { FactoryBot.create(:mentor, :onboarded, :geocoded) }
  let!(:join_request) { mentor.join_requests.create!(team: student.team) }

  before do
    sign_in(student)

    click_link "My Team"
    click_link "Mentors"
  end

  context "when a student approves a mentor's join request" do
    before do
      click_link "Approve"
      click_button "Yes, do it"
    end

    it "displays an approved message" do
      expect(page).to have_content("#{mentor.first_name} was approved")
    end

    it "displays the mentor's details on the Mentors page" do
      click_link "Mentors"

      expect(page).to have_content(mentor.name)
      expect(page).to have_content(mentor.email)
    end
  end

  context "when a student declines a mentor's join request" do
    before do
      click_link "Decline"
      click_button "Yes, do it"
    end

    it "displays a declined message" do
      expect(page).to have_content("Mentor was declined")
    end
  end
end
