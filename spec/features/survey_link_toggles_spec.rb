require "rails_helper"

RSpec.feature "Set survey links and link text" do
  %w{student mentor}.each do |scope|
    scenario "#{scope} survey link is configured" do
      SeasonToggles.public_send("#{scope}_survey_link=", {
        :text => "link text",
        :url => "google.com"
      })

      user = FactoryGirl.create(scope)

      sign_in(user)

      expect(current_path).to eq(public_send("#{scope}_dashboard_path"))
      expect(page).to have_link("link text", href: "google.com")
    end
  end
end

