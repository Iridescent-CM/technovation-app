require "rails_helper"

RSpec.feature "Configurable dashboard text per user type" do
  before do
    %w[judge].each do |scope|
      SeasonToggles.public_send("#{scope}_dashboard_text=", "")
    end
  end

  %w[judge].each do |scope|
    scenario "#{scope} dashboard" do
      SeasonToggles.public_send(
        "#{scope}_dashboard_text=",
        "Some sort of user message"
      )

      user = FactoryBot.create(scope)
      sign_in(user)

      visit public_send("#{scope}_dashboard_path")

      expect(page).to have_text("Some sort of user message")
    end
  end
end
