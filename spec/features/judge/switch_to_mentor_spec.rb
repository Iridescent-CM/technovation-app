require "rails_helper"

RSpec.feature "Judges switch to mentor mode", :js do

  context "config ON" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_SWITCH_BETWEEN_JUDGE_AND_MENTOR", any_args).and_return(true)
    end

    scenario "judges can switch to mentor profile" do
      judge = FactoryBot.create(:judge, :onboarded)

      sign_in(judge)

      expect(judge.is_a_mentor?).to be_falsey

      click_link "Switch to Mentor mode"
      expect(page).to have_link "Switch to Judge mode" # wait for turbolinks

      expect(current_path).to eq(mentor_dashboard_path)
      expect(judge.reload.is_a_mentor?).to be_truthy

      click_link "Switch to Judge mode"
      expect(page).to have_link "Switch to Mentor mode" # wait for turbolinks

      expect(current_path).to eq(judge_dashboard_path)
    end
  end

  context "config OFF" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_SWITCH_BETWEEN_JUDGE_AND_MENTOR", any_args).and_return(false)
    end

    scenario "judges do not see mentor mode link" do
      judge = FactoryBot.create(:judge, :onboarded)

      sign_in(judge)

      expect(current_path).to eq(judge_dashboard_path)
      expect(page).not_to have_link("Switch to Mentor mode")
    end
  end
end
    