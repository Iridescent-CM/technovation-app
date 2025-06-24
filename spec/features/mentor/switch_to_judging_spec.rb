require "rails_helper"

RSpec.feature "Mentors switching to judging mode", :js do
  let(:mentor) { FactoryBot.create(:mentor, :onboarded) }

  context "when ENABLE_JUDGE_MODE_FOR_ALL_MENTORS is enabled" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_JUDGE_MODE_FOR_ALL_MENTORS", any_args).and_return(true)
    end

    scenario "displaying the judge mode link" do
      sign_in(mentor)

      expect(page).to have_selector("a", text: "Switch to Judge Mode", visible: false)
    end

    scenario "creating a new judge profile for the mentor" do
      sign_in(mentor)
      expect(mentor.is_a_judge?).to eq(false)

      visit judge_dashboard_path
      expect(mentor.reload.is_a_judge?).to eq(true)
    end
  end

  context "when ENABLE_JUDGE_MODE_FOR_ALL_MENTORS is disabled" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_JUDGE_MODE_FOR_ALL_MENTORS", any_args).and_return(false)
    end

    scenario "not displaying the judge mode link" do
      sign_in(mentor)

      expect(page).not_to have_selector("a", text: "Switch to Judge Mode", visible: false)
    end
  end
end
