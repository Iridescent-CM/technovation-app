require "rails_helper"

RSpec.feature "Set survey links and link text", :js do
  %w{student mentor}.each do |scope|
    context "#{scope} survey link is configured" do
      let(:user) { FactoryBot.create(scope) }

      before do
        SeasonToggles.set_dashboard_text(scope, "this is a dependency")
        SeasonToggles.set_survey_link(scope, "link text", "google.com")
      end

      scenario "when they have not seen it yet" do
        allow(SeasonToggles).to receive(:show_survey_link_modal?)
          .and_return(true)

        sign_in(user)

        expect(current_path).to eq(public_send("#{scope}_dashboard_path"))
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

        expect(current_path).to eq(public_send("#{scope}_dashboard_path"))
        expect(page).to have_link("link text", href: "google.com", count: 1)
        expect(page).not_to have_css(".swal2-modal")
      end
    end
  end
end

