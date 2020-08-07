require "rails_helper"

RSpec.describe "Regional Pitch Events", :js do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador, :approved) }

  before do
    allow(ENV).to receive(:fetch).and_call_original
  end

  it "successfully creates a new event" do
    sign_in(chapter_ambassador)

    click_link "Events"
    click_button "Add an event"

    find("#new-event .grid div:nth-child(5) label").click
    all(".dayContainer .flatpickr-day:not(.disabled)").first.click
    expect(find_field("Date").value).to be_present

    find("#new-event .grid div:nth-child(6) label:nth-child(1)").click
    find(".numInputWrapper:nth-child(1)").hover
    find(".arrowDown").click
    expect(find_field("From").value).to be_present

    find("#new-event .grid div:nth-child(6) label:nth-child(2)").click
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

  it "successfully updates an event" do
    FactoryBot.create(:regional_pitch_event, ambassador: chapter_ambassador)
    expect(RegionalPitchEvent.count).to be_present

    sign_in(chapter_ambassador)

    click_link "Events"
    find("img[alt='edit']").click
    fill_in "Event name", with: "Main Event"
    click_button "Save changes"

    within ".vue-events-table" do
      expect(page).to have_content "Main Event"
    end
  end

  it "sucessfully deletes an event" do
    FactoryBot.create(:regional_pitch_event, ambassador: chapter_ambassador)
    expect(RegionalPitchEvent.count).to be_present

    sign_in(chapter_ambassador)

    click_link "Events"
    find("img[alt='remove']").click
    click_button "Yes, delete this event"

    expect(page).to have_content "Regional pitch event was successfully deleted"
  end
end
