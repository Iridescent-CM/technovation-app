require "rails_helper"

RSpec.feature "Survey link formatting" do
  %i{mentor student}.each do |scope|
    scenario "custom variables for #{scope}s are filled in dynamically" do
      url = "https://www.example.com/some/path"
      url += "?email=[email_value]"
      url += "&country=[country_value]"
      url += "&state=[state_value]"
      url += "&name=[name_value]"
      url += "&city=[city_value]"
      url += "&age=[age_value]"
      url += "&school=[school_value]"
      url += "&team=[team_value]"

      SeasonToggles.set_survey_link(
        scope,
        "Short headline",
        url,
      )

      profile = FactoryBot.create("onboarded_#{scope}", :geocoded)
      account = profile.account
      sign_in(profile)

      expected_url = "https://www.example.com/some/path"
      expected_url += "?email=#{account.email}"
      expected_url += "&country=#{FriendlyCountry.(account)}"
      expected_url += "&state=#{FriendlySubregion.(account)}"
      expected_url += "&name=#{account.full_name}"
      expected_url += "&city=#{account.city}"
      expected_url += "&age=#{account.age}"
      expected_url += "&school=#{profile.school_company_name}"
      expected_url += "&team=#{profile.team_names.join(", ")}"

      expect(page).to have_link("Short headline", href: expected_url)
    end
  end
end
