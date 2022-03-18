require "rails_helper"

RSpec.feature "Set survey links and link text", :js do
  context "student survey link is configured" do
    let(:user) { FactoryBot.create(:student) }

    before do
      SeasonToggles.set_dashboard_text(:student, "this is a dependency")
      SeasonToggles.set_survey_link(:student, "link text", "google.com")
    end

    scenario "when they have not seen it yet" do
      allow(SeasonToggles).to receive(:show_survey_link_modal?)
        .and_return(true)

      sign_in(user)

      expect(current_path).to eq(public_send("student_dashboard_path"))
      expect(page).to have_link("link text", href: "google.com", count: 2)

      expect(page).to have_css(".swal2-modal")
      within(".swal2-modal") do
        expect(page).to have_link("link text", href: "google.com")
      end
    end

    scenario "when they have seen it" do
      allow(SeasonToggles).to receive(:show_survey_link_modal?)
        .and_return(false)

      sign_in(user)

      expect(current_path).to eq(public_send("student_dashboard_path"))

      find('#global-dropdown-wrapper').click
      expect(page).to have_link("link text", href: "google.com", count: 2)

      expect(page).not_to have_css(".swal2-modal")
    end
  end

  context "mentor survey link is configured" do
    let(:mentor) { FactoryBot.create(:mentor) }

    before do
      SeasonToggles.set_dashboard_text(:mentor, "this is a dependency")
      SeasonToggles.set_survey_link(:mentor, "link text", "google.com")
    end

    scenario "when they have not seen it yet" do
      allow(SeasonToggles).to receive(:show_survey_link_modal?)
        .and_return(true)

      sign_in(mentor)

      expect(current_path).to eq(public_send("mentor_dashboard_path"))
      expect(page).to have_link("link text", href: "google.com", count: 2)

      expect(page).to have_css(".swal2-modal")
      within(".swal2-modal") do
        expect(page).to have_link("link text", href: "google.com")
      end
    end

    scenario "when they have seen it" do
      allow(SeasonToggles).to receive(:show_survey_link_modal?)
        .and_return(false)

      sign_in(mentor)

      expect(current_path).to eq(public_send("mentor_dashboard_path"))
      expect(page).to have_link("link text", href: "google.com", count: 1)

      expect(page).not_to have_css(".swal2-modal")
    end
  end
end


