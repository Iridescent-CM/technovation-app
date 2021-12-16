require "rails_helper"

RSpec.xfeature "Student receives mentor request to join their team", js: true do
  before { SeasonToggles.team_building_enabled="yes" }

  let(:student) { FactoryBot.create(:student, :geocoded, :on_team) }
  let!(:mentor) { FactoryBot.create(:mentor, :onboarded, :geocoded) }

  let!(:join_request) { mentor.join_requests.create!(team: student.team) }

  let(:mentors_page_path) { student_team_path(student.team, anchor: "mentors") }

  before do
    sign_in(student)
    visit mentors_page_path
  end

  context "from the My Team page" do
    scenario "Student approves the request" do
      within "#join_request_#{join_request.id}" do
        click_link "approve"
      end
      click_button "Yes, do it"

      expect(page).to have_content("#{mentor.first_name} was approved")
      within("#mentors") do
        expect(page).to have_content(mentor.name)
        expect(page).to have_content(mentor.email)
      end
    end
      
    scenario "Student declines the request" do
      within "#join_request_#{join_request.id}" do
        click_link "decline"
      end
      click_button "Yes, do it"

      expect(page).to have_content("Mentor was declined")
      expect(page).to have_content("Your team doesn't have any mentors!")
    end
  end

  context "from the mentor's profile" do
    before do
      within "#join_request_#{join_request.id}" do
        click_link "view profile"
      end
      expect(page).to have_content("Mentor details")
    end

    scenario "Student uses the back link" do
      click_link "Back to your team"
      expect(page).to have_content("#{student.team_name}")
      expect(page).to have_content("Your team doesn't have any mentors!")
    end

    scenario "Student approves the request" do
      click_link "approve"
      click_button "Yes, do it"

      expect(page).to have_content("#{mentor.first_name} was approved")
      within("#mentors") do
        expect(page).to have_content(mentor.name)
        expect(page).to have_content(mentor.email)
      end
    end

    scenario "Student declines the request" do
      click_link "decline"
      click_button "Yes, do it"

      expect(page).to have_content("Mentor was declined")
      expect(page).to have_content("Your team doesn't have any mentors!")
    end
  end
end
