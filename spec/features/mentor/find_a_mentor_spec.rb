require "rails_helper"

RSpec.feature "Mentors find a team" do
  let(:day_before_qfs) { ImportantDates.quarterfinals_judging_begins - 1.day }
  let(:current_season) { Season.new(day_before_qfs.year) }

  before do
    allow(Season).to receive(:current).and_return(current_season)
    Timecop.freeze(day_before_qfs)

    mentor = FactoryBot.create(:mentor, :onboarded, :geocoded) # City is Chicago
    sign_in(mentor)
  end

  let!(:find_mentor) do
    FactoryBot.create(:mentor, :onboarded, :geocoded, :searchable_by_other_mentors, first_name: "Findme") # City is Chicago
  end

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

    expect(page).to have_content("Findme")
    expect(page).not_to have_content("Faraway")
  end

  scenario "search for a mentor by first name" do
    FactoryBot.create(
      :mentor,
      :onboarded,
      :geocoded,
      :searchable_by_other_mentors,
      first_name: "Faraway",
      last_name: "Mentor",
      city: "Los Angeles",
      state_province: "CA"
    )

    click_link "Connect with mentors"

    fill_in "text", with: "araw" # partial match
    fill_in "nearby", with: "anywhere"
    page.find("form").submit_form!

    expect(page).to have_content("Faraway")
    expect(page).not_to have_content("Findme")
  end

  scenario "search for a mentor by last name" do
    FactoryBot.create(
      :mentor,
      :onboarded,
      :geocoded,
      :searchable_by_other_mentors,
      first_name: "Faraway",
      last_name: "Mentor",
      city: "Los Angeles",
      state_province: "CA"
    )

    click_link "Connect with mentors"

    fill_in "text", with: "mento" # partial match
    fill_in "nearby", with: "anywhere"
    page.find("form").submit_form!

    expect(page).to have_content("Faraway")
    expect(page).not_to have_content("Findme")
  end

  scenario "search for a mentor by first and last name" do
    FactoryBot.create(
      :mentor,
      :onboarded,
      :geocoded,
      :searchable_by_other_mentors,
      first_name: "Traditional Person",
      last_name: "Family Name",
      city: "Los Angeles",
      state_province: "CA"
    )

    click_link "Connect with mentors"

    fill_in "text", with: "traditi fam na" # partial match
    fill_in "nearby", with: "anywhere"
    page.find("form").submit_form!

    expect(page).to have_content("Traditional")
    expect(page).not_to have_content("Findme")
  end

  scenario "visit the mentor page" do
    click_link "Connect with mentors"
    click_link "View more details"

    expect(page).to have_content(find_mentor.full_name)
  end
end
