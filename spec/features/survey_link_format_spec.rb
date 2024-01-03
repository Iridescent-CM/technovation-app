require "rails_helper"

RSpec.feature "Survey link formatting", :js do
  %i[mentor student].each do |scope|
    scenario "custom variables for #{scope}s are filled in dynamically" do
      url = "https://www.example.com/some/path"
      url += "?email=[email_value]"
      url += "&country=[country_value]"
      url += "&state=[state_value]"
      url += "&name=[name_value]"
      url += "&city=[city_value]"
      url += "&age=[age_value]"
      url += "&school=[school_value]"
      url += "&company=[company_value]"
      url += "&team=[team_value]"

      SeasonToggles.set_survey_link(
        scope,
        "Short headline",
        url
      )

      profile_without_team = FactoryBot.create("onboarded_#{scope}", :geocoded)
      account = profile_without_team.account
      sign_in(profile_without_team)

      expected_url = "https://www.example.com/some/path"
      expected_url += "?email=#{account.email}"
      expected_url += "&country=#{FriendlyCountry.call(account)}"
      expected_url += "&state=#{FriendlySubregion.call(account)}"
      expected_url += "&name=#{account.full_name}"
      expected_url += "&city=#{account.city}"
      expected_url += "&age=#{account.age}"
      expected_url += "&school=#{account.profile_school_company_name}"
      expected_url += "&company=#{account.profile_school_company_name}"
      expected_url += "&team="

      expect(page).to have_link("Short headline", href: expected_url)

      profile_with_team = FactoryBot.create("onboarded_#{scope}", :geocoded, :on_team)
      account = profile_with_team.account
      sign_in(profile_with_team)

      expected_url = "https://www.example.com/some/path"
      expected_url += "?email=#{account.email}"
      expected_url += "&country=#{FriendlyCountry.call(account)}"
      expected_url += "&state=#{FriendlySubregion.call(account)}"
      expected_url += "&name=#{account.full_name}"
      expected_url += "&city=#{account.city}"
      expected_url += "&age=#{account.age}"
      expected_url += "&school=#{account.profile_school_company_name}"
      expected_url += "&company=#{account.profile_school_company_name}"
      expected_url += "&team=#{account.profile_team_names.join(", ")}"

      expect(page).to have_link("Short headline", href: expected_url)
    end
  end
end
