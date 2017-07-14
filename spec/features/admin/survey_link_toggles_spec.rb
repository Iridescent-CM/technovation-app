require "rails_helper"

RSpec.feature "Set survey links and link text" do
  %w{student mentor}.each do |scope|
    context "#{scope} survey link is configured" do
      let(:user) { FactoryGirl.create(scope) }

      before do
        SeasonToggles.public_send("#{scope}_survey_link=", {
          :text => "link text",
          :url => "google.com"
        })
      end

      scenario "with modal" do
        sign_in(user)

        expect(current_path).to eq(public_send("#{scope}_dashboard_path"))
        expect(page).to have_link("link text", href: "google.com", count: 2)
        expect(page).to have_css("#survey_interrupt")
        within("#survey_interrupt") do
          expect(page).to have_link("link text", href: "google.com")
        end
      end

      scenario "without modal" do
        page.driver.browser.set_cookie("last_seen_survey_modal=#{SeasonToggles.survey_link(scope, "changed_at")}")

        sign_in(user)

        expect(current_path).to eq(public_send("#{scope}_dashboard_path"))
        expect(page).to have_link("link text", href: "google.com", count: 1)
        expect(page).not_to have_css("#survey_interrupt")
      end
    end
  end
end

