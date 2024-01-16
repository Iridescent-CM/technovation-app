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

      click_link "Events"

      expect(page).to have_content("Add an event")
    end

    it "successfully creates a new event" do
      sign_in(chapter_ambassador)
      visit(chapter_ambassador_chapter_admin_path)

      click_link "Events"
      click_button "Add an event"

      find("label#event-date").click
      all(".dayContainer .flatpickr-day:not(.disabled)").first.click
      expect(find_field("Date").value).to be_present

      find("label#event-start-time").click
      find(".numInputWrapper:nth-child(1)").hover
      find(".arrowDown").click
      expect(find_field("From").value).to be_present

      find("label#event-end-time").click
      find(".numInputWrapper:nth-child(1)").hover
      find(".arrowUp").click
      expect(find_field("To").value).to be_present

      fill_in "Event name", with: "Super Event"
      fill_in "City", with: "New City"
      fill_in "Venue address", with: "123 45th St"
      choose "Senior division"

      click_button "Create this event"

      within ".vue-events-table" do
        expect(page).to have_content "Super Event"
      end
    end
  end

  context "when regional pitch event creation is disabled" do
    let(:create_regional_pitch_event_enabled) { false }

    before do
      sign_in(chapter_ambassador)
      visit(chapter_ambassador_chapter_admin_path)

      click_link "Events"
    end

    it "displays an error message indictating that events can't be created" do
      expect(page).to have_content("New events cannot be created")
    end

    it "does not display an 'Add an event' button" do
      expect(page).not_to have_content("Add an event")
    end
  end

  it "successfully updates an event" do
    FactoryBot.create(:regional_pitch_event, ambassador: chapter_ambassador)
    expect(RegionalPitchEvent.count).to be > 0

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_chapter_admin_path)

    click_link "Events"
    find("img[alt='edit']").click
    fill_in "Event name", with: "Main Event"
    choose "Senior division"
    click_button "Save changes"

    within ".vue-events-table" do
      expect(page).to have_content "Main Event"
    end
  end

  it "sucessfully deletes an event" do
    FactoryBot.create(:regional_pitch_event, ambassador: chapter_ambassador)
    expect(RegionalPitchEvent.count).to be > 0

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_chapter_admin_path)

    click_link "Events"
    find("img[alt='remove']").click
    click_button "Yes, delete this event"

    expect(page).to have_content "Regional pitch event was successfully deleted"
  end
end
