require "rails_helper"

RSpec.feature "Mentors find a team" do
  let(:today) { ImportantDates.quarterfinals_judging_begins - 1.day }
  let(:current_season) { Season.new(today.year) }

  before do
    allow(Season).to receive(:current).and_return(current_season)
    Timecop.freeze(today)

    mentor = FactoryBot.create(:mentor, :onboarded, :geocoded) # City is Chicago
    sign_in(mentor)
  end

  let!(:find_mentor) {
    FactoryBot.create(:mentor, :onboarded, :geocoded, first_name: "Findme")
  } # City is Chicago

  after do
    Timecop.return
  end

  scenario "only see current mentors" do
    FactoryBot.create(:mentor, :onboarded, :geocoded)
    past = FactoryBot.create(
      :mentor,
      :onboarded,
      :geocoded,
      first_name: "Not me"
    )

    past.account.update(
      seasons: [current_season.year - 1]
    )

    click_link "Connect with mentors"

    expect(page).not_to have_content("Not me")
  end

  scenario "browse nearby mentors" do
    FactoryBot.create(
      :mentor,
      :onboarded,
      :geocoded,
      first_name: "Faraway",
      city: "Los Angeles",
      state_province: "CA"
    )

    click_link "Connect with mentors"

    within(".search-result-head") do
      expect(page).to have_content("Findme")
      expect(page).not_to have_content("Faraway")
    end
  end

  scenario "search for a mentor by first name" do
    FactoryBot.create(
      :mentor,
      :onboarded,
      :geocoded,
      first_name: "Faraway",
      last_name: "Mentor",
      city: "Los Angeles",
      state_province: "CA"
    )

    click_link "Connect with mentors"

    fill_in "text", with: "araw" # partial match
    fill_in "nearby", with: "anywhere"
    page.find("form").submit_form!

    expect(page).to have_css(".search-result-head", text: "Faraway")
    expect(page).not_to have_css(".search-result-head", text: "Findme")
  end

  scenario "search for a mentor by last name" do
    FactoryBot.create(
      :mentor,
      :onboarded,
      :geocoded,
      first_name: "Faraway",
      last_name: "Mentor",
      city: "Los Angeles",
      state_province: "CA"
    )

    click_link "Connect with mentors"

    fill_in "text", with: "mento" # partial match
    fill_in "nearby", with: "anywhere"
    page.find("form").submit_form!

    expect(page).to have_css(".search-result-head", text: "Faraway")
    expect(page).not_to have_css(".search-result-head", text: "Findme")
  end

  scenario "search for a mentor by first and last name" do
    FactoryBot.create(
      :mentor,
      :onboarded,
      :geocoded,
      first_name: "Traditional Mexican",
      last_name: "Family Name",
      city: "Los Angeles",
      state_province: "CA"
    )

    click_link "Connect with mentors"

    fill_in "text", with: "traditi mexic fam na" # partial match
    fill_in "nearby", with: "anywhere"
    page.find("form").submit_form!

    expect(page).to have_css(".search-result-head", text: "Traditional")
    expect(page).not_to have_css(".search-result-head", text: "Findme")
  end

  scenario "visit the mentor page" do
    click_link "Connect with mentors"
    click_link "Connect with #{find_mentor.first_name}"

    expect(page).to have_css(
      "a[href=\"mailto:#{find_mentor.email}\"]",
      text: find_mentor.email
    )
  end
end
