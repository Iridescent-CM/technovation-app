require "rails_helper"

RSpec.feature "Mentors find a team" do
  before { SeasonToggles.team_building_enabled! }

  let!(:available_team) { FactoryBot.create(:team, :geocoded) }
    # Default is in Chicago

  let(:mentor) { FactoryBot.create(:mentor, :onboarded, :geocoded) } # City is Chicago

  before { sign_in(mentor) }

  scenario "browse nearby teams" do
    mentored_team = FactoryBot.create(:team, :with_mentor, :geocoded)
    faraway_team = FactoryBot.create(
      :team,
      :geocoded,
      city: "Los Angeles",
      state_province: "CA"
    )

    within('#find-team') { click_link "Find a team" }

    expect(page).to have_css(
      ".search-result-head",
      text: available_team.name
    )

    expect(page).to have_css(
      ".search-result-head",
      text: mentored_team.name
    )

    expect(page).not_to have_css(
      ".search-result-head",
      text: faraway_team.name
    )
  end

  scenario "search for a team by name" do
    mentored_team = FactoryBot.create(:team, :with_mentor, :geocoded)

    FactoryBot.create(
      :team,
      :geocoded,
      name: "faraway",
      city: "Los Angeles",
      state_province: "CA"
    )

    within('#find-team') { click_link "Find a team" }

    fill_in "text", with: "araw" # partial match
    fill_in "nearby", with: "anywhere"
    page.find("form").submit_form!

    expect(page).to have_css(".search-result-head", text: "faraway")

    expect(page).not_to have_css(
      ".search-result-head",
      text: available_team.name
    )

    expect(page).not_to have_css(
      ".search-result-head",
      text: mentored_team.name
    )
  end

  scenario "search for a team by junior division" do
    junior_team = FactoryBot.create(:team, :junior, :geocoded)
    senior_team = FactoryBot.create(:team, :senior, :geocoded)

    within('#find-team') { click_link "Find a team" }

    check "Junior"
    uncheck "Senior"
    uncheck "None assigned yet"
    page.find("form").submit_form!

    expect(page).not_to have_css(
      ".search-result-head",
      text: senior_team.name
    )

    expect(page).to have_css(
      ".search-result-head",
      text: junior_team.name
    )
  end

  scenario "search for a team by senior division" do
    junior_team = FactoryBot.create(:team, :junior, :geocoded)
    senior_team = FactoryBot.create(:team, :senior, :geocoded)

    within('#find-team') { click_link "Find a team" }

    check "Senior"
    uncheck "Junior"
    uncheck "None assigned yet"
    page.find("form").submit_form!

    expect(page).not_to have_css(
      ".search-result-head",
      text: junior_team.name
    )

    expect(page).to have_css(
      ".search-result-head",
      text: senior_team.name
    )
  end

  scenario "request to join a team" do
    Timecop.freeze(ImportantDates.quarterfinals_judging_begins - 1.day) do
      within('#find-team') { click_link "Find a team" }

      click_link "Ask to join"
      click_button "Ask to be a mentor for #{available_team.name}"

      join_request = JoinRequest.last

      expect(current_path).to eq(mentor_join_request_path(join_request))
      expect(page).to have_content(join_request.team_name)
      expect(page).to have_content(
        "You have requested to be a mentor for #{available_team.name}"
      )
      expect(page).to have_content("You have requested to join this team")
    end
  end

  scenario "request to join the same team again, even if you deleted an earlier request" do
    Timecop.freeze(ImportantDates.quarterfinals_judging_begins - 1.day) do
      join_request = JoinRequest.create!({
        requestor: mentor,
        team: available_team,
      })

      join_request.deleted!

      within('#find-team') { click_link "Find a team" }

      click_link "Ask to join"
      click_button "Ask to be a mentor for #{available_team.name}"

      expect(current_path).to eq(mentor_join_request_path(join_request))
      expect(page).to have_content("You have requested to join this team")
      expect(page).to have_content(join_request.team_name)
    end
  end
end
