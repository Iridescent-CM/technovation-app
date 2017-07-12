require "rails_helper"

RSpec.feature "Admin UI for season toggles:" do
  before do
    sign_in(FactoryGirl.create(:admin))
    click_link "Season Schedule Settings"
  end

  scenario "toggle user signups" do
    %w{student mentor judge regional_ambassador}.each do |scope|
      SeasonToggles.disable_signup(scope)
      click_link "Season Schedule Settings"

      check "#{scope.humanize.capitalize} signup"
      click_button "Save"

      expect(SeasonToggles.signup_enabled?(scope)).to be(true),
        "#{scope} signup was not enabled"
    end
  end

  scenario "set dashboard headlines" do
    %w{student mentor judge}.each do |scope|
      SeasonToggles.set_dashboard_text(scope, "")
      click_link "Season Schedule Settings"

      fill_in "#{scope.humanize.capitalize} dashboard text",
        with: "Something short"

      click_button "Save"

      expect(SeasonToggles.dashboard_text(scope)).to eq("Something short"),
        "#{scope} dashboard text was not set"
    end
  end

  scenario "set the survey links" do
    %w{student mentor}.each do |scope|
      SeasonToggles.set_survey_link(scope, nil, nil)
      click_link "Season Schedule Settings"

      fill_in "season_toggles_#{scope}_survey_link_text", with: "Pre-survey"
      fill_in "season_toggles_#{scope}_survey_link_url", with: "google.com"

      click_button "Save"

      expect(SeasonToggles.survey_link(scope, :text)).to eq("Pre-survey"),
        "#{scope} survey link text was not set"

      expect(SeasonToggles.survey_link(scope, :url)).to eq("google.com"),
        "#{scope} survey link url was not set"
    end
  end

  scenario "configure team submissions editable" do
    SeasonToggles.team_submissions_editable = false
    click_link "Season Schedule Settings"

    check "Make Team Submissions Editable?"
    click_button "Save"

    expect(SeasonToggles.team_submissions_editable?).to be true
  end
end
