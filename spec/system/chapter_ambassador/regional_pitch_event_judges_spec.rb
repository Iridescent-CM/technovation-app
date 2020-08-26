require "rails_helper"

RSpec.describe "Regional Pitch Event Judges", :js do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador, :approved) }

  context "when MANAGE_EVENTS is enabled" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("MANAGE_EVENTS", any_args).and_return(true)
    end

    it "successfully adds a judge an event" do
      FactoryBot.create(:regional_pitch_event, ambassador: chapter_ambassador)
      FactoryBot.create(:judge, first_name: "Judge B12")
      expect(RegionalPitchEvent.count).to be_present
      expect(Team.count).to be_present

      sign_in(chapter_ambassador)

      click_link "Events"
      find("img[alt='edit judges']").click
      expect(page).to have_content("ADD JUDGES")

      click_button "Add judges"
      find("img[src*='check-circle-o.svg']").click
      click_button "Done"
      click_button "Save changes"

      expect(page).to have_content "You saved your selected attendees"

      within("table.attendee-list") do
        expect(page).to have_content "Judge B12"
      end
    end

    it "successfully removes a judge from an event" do
      event = FactoryBot.create(:regional_pitch_event, ambassador: chapter_ambassador)
      judge = FactoryBot.create(:judge, first_name: "Judge P.")
      expect(RegionalPitchEvent.count).to be_present
      expect(Team.count).to be_present
      event.judges = [judge]

      sign_in(chapter_ambassador)

      click_link "Events"
      find("img[alt='edit judges']").click

      within("table.attendee-list") do
        expect(page).to have_content "Judge P."
      end

      find("table.attendee-list td:first-child").hover
      find(".attendee-list__actions img[src*='remove.svg']").click
      click_button "Yes, remove this judge"

      expect(page).to have_content "You removed Judge P."
    end
  end

  context "when MANAGE_EVENTS is disabled" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("MANAGE_EVENTS", any_args).and_return(false)
    end

    it "does not display the 'Edit Judges' icon/link" do
      sign_in(chapter_ambassador)

      click_link "Events"
      expect(page).not_to have_css("img[alt='edit judges']")
    end
  end
end
