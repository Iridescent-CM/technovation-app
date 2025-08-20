require "rails_helper"

RSpec.feature "Judges switching to mentor mode", :js do
  let(:judge) { FactoryBot.create(:judge, :onboarded) }

  context "when ENABLE_MENTOR_MODE_FOR_ALL_JUDGES is enabled" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_MENTOR_MODE_FOR_ALL_JUDGES", any_args).and_return(true)
    end

    scenario "displaying the mentor mode link" do
      sign_in(judge)

      expect(page).to have_link("Mentor Mode")
    end

    scenario "creating a new mentor profile for the judge" do
      sign_in(judge)
      expect(judge.is_a_mentor?).to eq(false)

      click_link "Mentor Mode"

      expect(page).to have_content("Find a Chapter or Club")
      expect(judge.reload.is_a_mentor?).to eq(true)
    end
  end

  context "when ENABLE_MENTOR_MODE_FOR_ALL_JUDGES is disabled" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_MENTOR_MODE_FOR_ALL_JUDGES", any_args).and_return(false)
    end

    scenario "not displaying the mentor mode link" do
      sign_in(judge)

      expect(page).not_to have_link("Mentor Mode")
    end
  end
end
