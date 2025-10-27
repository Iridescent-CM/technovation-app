require "rails_helper"

RSpec.describe "Regional Pitch Events", :js do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador, :approved) }

  before do
    allow(ENV).to receive(:fetch).and_call_original

    allow(SeasonToggles).to receive(:create_regional_pitch_event?)
      .and_return(create_regional_pitch_event_enabled)
  end

  let(:create_regional_pitch_event_enabled) { true }

  context "when regional pitch event creation is enabled" do
    let(:create_regional_pitch_event_enabled) { true }

    it "displays an 'Add an event' button" do
      sign_in(chapter_ambassador)
      visit(chapter_ambassador_chapter_admin_path)

      click_link "Events List"

      expect(page).to have_content("Add an event")
    end

    it "successfully creates a new event" do
      sign_in(chapter_ambassador)
      visit(chapter_ambassador_chapter_admin_path)

      click_link "Events List"
      click_link "Add an event"

      fill_in "Event starts at", with: 1.week.from_now.strftime("%Y-%m-%dT%H:%M")
      fill_in "Event ends at", with: (1.week.from_now + 2.hours).strftime("%Y-%m-%dT%H:%M")
      fill_in "Event Name", with: "Super Event"
      fill_in "City", with: "New City"
      fill_in "Venue address", with: "123 45th St"
      choose "Senior Division"

      click_button "Create this event"

      expect(page).to have_content "Super Event"
    end
  end

  context "when regional pitch event creation is disabled" do
    let(:create_regional_pitch_event_enabled) { false }

    before do
      sign_in(chapter_ambassador)
      visit(chapter_ambassador_chapter_admin_path)

      click_link "Events List"
    end

    it "displays an error message indicating that events can't be created" do
      expect(page).to have_content("New events cannot be created")
    end

    it "does not display an 'Add an event' button" do
      expect(page).not_to have_content("Add an event")
    end
  end

  it "successfully updates an event" do
    event = FactoryBot.create(:regional_pitch_event, ambassador: chapter_ambassador)
    expect(RegionalPitchEvent.count).to be > 0

    sign_in(chapter_ambassador)
    visit(edit_chapter_ambassador_regional_pitch_event_path(event))

    fill_in "Event Name", with: "Main Event"
    choose "Senior Division"
    click_button "Update"
    expect(page).to have_content "Main Event"
  end

  xit "successfully deletes an event" do
    FactoryBot.create(:regional_pitch_event, ambassador: chapter_ambassador, name: "Evening Event #2")
    expect(RegionalPitchEvent.count).to be > 0

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_chapter_admin_path)

    click_link "Events List"
    expect(page).to have_content "Evening Event #2"

    click_link "Delete"
    click_button "Yes, delete this event"

    expect(page).not_to have_content "Evening Event #2"
  end
end
