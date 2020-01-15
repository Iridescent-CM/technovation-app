require "rails_helper"

feature "RAs switch to judge mode from RA dashboard" do
  feature "with config on" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_RA_SWITCH_TO_JUDGE", any_args).and_return(true)
    end

    scenario "an RA with a judge profile switches to judge mode" do
      regional_ambassador = FactoryBot.create(:regional_ambassador, :approved, :has_judge_profile)

      sign_in(regional_ambassador)

      expect(regional_ambassador.is_a_judge?).to be_truthy

      click_link "Judge Mode"
      expect(current_path).to eq(judge_dashboard_path)
    end

    scenario "an RA switches back to RA mode from judge mode" do
      regional_ambassador = FactoryBot.create(:regional_ambassador, :approved, :has_judge_profile)

      sign_in(regional_ambassador)

      click_link "Judge Mode"
      expect(current_path).to eq(judge_dashboard_path)

      click_link "Switch to RA mode"
      expect(current_path).to eq(regional_ambassador_dashboard_path)
    end

    scenario "a judge without an RA profile cannot switch to RA mode" do
      judge = FactoryBot.create(:judge, :onboarded)
      sign_in(judge)
      expect(page).not_to have_link("Switch to RA mode")

      visit regional_ambassador_dashboard_path
      expect(current_path).to eq(judge_dashboard_path)
    end

    scenario "an RA without a judge profile does not see a judge mode link" do
      regional_ambassador = FactoryBot.create(:regional_ambassador, :approved)

      sign_in(regional_ambassador)

      expect(regional_ambassador.is_a_judge?).to be_falsey

      expect(page).not_to have_link("Judge Mode")
    end

    scenario "RAs without a judge profile cannot browse to judge profile" do
      regional_ambassador = FactoryBot.create(:regional_ambassador, :approved)

      sign_in(regional_ambassador)

      visit judge_dashboard_path

      expect(current_path).to eq(regional_ambassador_dashboard_path)
      expect(page).to have_content("You don't have permission to go there!")
    end
  end

  feature "with config off" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_RA_SWITCH_TO_JUDGE", any_args).and_return(false)
    end

    scenario "RAs with a judge profile do not see judge mode link" do
      regional_ambassador = FactoryBot.create(:regional_ambassador, :approved, :has_judge_profile)

      sign_in(regional_ambassador)

      expect(regional_ambassador.is_a_judge?).to be_truthy
      expect(current_path).to eq(regional_ambassador_dashboard_path)

      expect(page).not_to have_link("Judge Mode")
    end

    scenario "RAs without a judge profile do not see a judge mode link" do
      regional_ambassador = FactoryBot.create(:regional_ambassador, :approved)

      sign_in(regional_ambassador)

      expect(regional_ambassador.is_a_judge?).to be_falsey
      expect(current_path).to eq(regional_ambassador_dashboard_path)

      expect(page).not_to have_link("Judge Mode")
    end
  end
end

feature "RAs switch to judge mode through mentor dashboard" do
  feature "with config on" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_RA_SWITCH_TO_JUDGE", any_args).and_return(true)
    end

    scenario "an RA with a judge profile switches to mentor mode then judge mode" do
      regional_ambassador = FactoryBot.create(:regional_ambassador, :approved, :has_judge_profile)

      sign_in(regional_ambassador)

      expect(regional_ambassador.is_a_judge?).to be_truthy

      click_link "Mentor Mode"
      expect(current_path).to eq(mentor_dashboard_path)

      click_link "Switch to Judge mode"
      expect(current_path).to eq(judge_dashboard_path)
    end

    scenario "an RA without a judge profile does not see a judge mode link on their mentor dashboard" do
      regional_ambassador = FactoryBot.create(:regional_ambassador, :approved)

      sign_in(regional_ambassador)

      expect(regional_ambassador.is_a_judge?).to be_falsey

      click_link "Mentor Mode"
      expect(current_path).to eq(mentor_dashboard_path)

      expect(page).not_to have_link("Switch to Judge mode")
    end
  end

  feature "with config off" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_RA_SWITCH_TO_JUDGE", any_args).and_return(false)
    end

    scenario "an RA with a judge profile does not see a judge mode link on their mentor dashboard" do
      regional_ambassador = FactoryBot.create(:regional_ambassador, :approved, :has_judge_profile)

      sign_in(regional_ambassador)

      expect(regional_ambassador.is_a_judge?).to be_truthy

      click_link "Mentor Mode"
      expect(current_path).to eq(mentor_dashboard_path)

      expect(page).not_to have_link("Switch to Judge mode")
    end

    scenario "an RA without a judge profile does not see a judge mode link on their mentor dashboard" do
      regional_ambassador = FactoryBot.create(:regional_ambassador, :approved)

      sign_in(regional_ambassador)

      expect(regional_ambassador.is_a_judge?).to be_falsey

      click_link "Mentor Mode"
      expect(current_path).to eq(mentor_dashboard_path)

      expect(page).not_to have_link("Switch to Judge mode")
    end
  end
end
