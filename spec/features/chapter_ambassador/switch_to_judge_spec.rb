require "rails_helper"

feature "chapter ambassadors switch to judge mode from chapter ambassador dashboard", :js do
  feature "with config on" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_CHAPTER_AMBASSADOR_SWITCH_TO_JUDGE", any_args).and_return(true)
    end

    scenario "a chapter ambassador with a judge profile switches to judge mode" do
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved, :has_judge_profile)

      sign_in(chapter_ambassador)
      visit(chapter_ambassador_chapter_admin_path)

      expect(chapter_ambassador.is_a_judge?).to be_truthy

      click_link "Judge Mode"
      expect(page).to have_text("Judging Rubric")
      expect(current_path).to eq(judge_dashboard_path)
    end

    scenario "a chapter ambassador  switches back to chapter ambassador mode from judge mode" do
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved, :has_judge_profile)

      sign_in(chapter_ambassador)
      visit(chapter_ambassador_chapter_admin_path)

      click_link "Judge Mode"
      expect(page).to have_text("Judging Rubric")
      expect(current_path).to eq(judge_dashboard_path)

      find("#global-dropdown-wrapper").click
      click_link "Chapter Ambassador Mode"
      expect(page).to have_text("Chapter Ambassador Dashboard")
      expect(current_path).to eq(chapter_ambassador_dashboard_path)
    end

    scenario "a judge without a chapter ambassador  profile cannot switch to chapter ambassador mode" do
      judge = FactoryBot.create(:judge, :onboarded)
      sign_in(judge)
      expect(page).not_to have_link("Switch to Chapter Ambassador mode")

      visit chapter_ambassador_dashboard_path
      expect(current_path).to eq(judge_dashboard_path)
    end

    scenario "a chapter ambassador without a judge profile does not see a judge mode link" do
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved)

      sign_in(chapter_ambassador)

      expect(chapter_ambassador.is_a_judge?).to be_falsey

      expect(page).not_to have_link("Judge Mode")
    end

    scenario "chapter ambassadors without a judge profile cannot browse to judge profile" do
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved)

      sign_in(chapter_ambassador)

      visit judge_dashboard_path

      expect(current_path).to eq(chapter_ambassador_dashboard_path)
      expect(page).to have_content("You don't have permission to go there!")
    end
  end

  feature "with config off" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_CHAPTER_AMBASSADOR_SWITCH_TO_JUDGE", any_args).and_return(false)
    end

    scenario "chapter ambassadors with a judge profile do not see judge mode link" do
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved, :has_judge_profile)

      sign_in(chapter_ambassador)

      expect(chapter_ambassador.is_a_judge?).to be_truthy
      expect(current_path).to eq(chapter_ambassador_dashboard_path)

      expect(page).not_to have_link("Judge Mode")
    end

    scenario "chapter ambassadors without a judge profile do not see a judge mode link" do
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved)

      sign_in(chapter_ambassador)

      expect(chapter_ambassador.is_a_judge?).to be_falsey
      expect(current_path).to eq(chapter_ambassador_dashboard_path)

      expect(page).not_to have_link("Judge Mode")
    end
  end
end

feature "chapter ambassadors switch to judge mode through mentor dashboard", :js do
  feature "with config on" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_CHAPTER_AMBASSADOR_SWITCH_TO_JUDGE", any_args).and_return(true)
    end

    scenario "a chapter ambassador with a judge profile switches to mentor mode then judge mode" do
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved, :has_judge_profile)

      sign_in(chapter_ambassador)

      expect(chapter_ambassador.is_a_judge?).to be_truthy

      click_link "Mentor Mode"
      expect(page).to have_link("Switch to Chapter Ambassador mode")
      expect(current_path).to eq(mentor_dashboard_path)

      click_link "Switch to Judge mode"
      expect(page).to have_text("Judging Rubric")
      expect(current_path).to eq(judge_dashboard_path)
    end

    scenario "a chapter ambassador without a judge profile does not see a judge mode link on their mentor dashboard" do
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved)

      sign_in(chapter_ambassador)

      expect(chapter_ambassador.is_a_judge?).to be_falsey

      click_link "Mentor Mode"
      expect(page).to have_link("Switch to Chapter Ambassador mode")
      expect(current_path).to eq(mentor_dashboard_path)

      expect(page).not_to have_link("Switch to Judge mode")
    end
  end

  feature "with config off" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_CHAPTER_AMBASSADOR_SWITCH_TO_JUDGE", any_args).and_return(false)
    end

    scenario "a chapter ambassador with a judge profile does not see a judge mode link on their mentor dashboard" do
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved, :has_judge_profile)

      sign_in(chapter_ambassador)

      expect(chapter_ambassador.is_a_judge?).to be_truthy

      click_link "Mentor Mode"
      expect(page).to have_link("Switch to Chapter Ambassador mode")
      expect(current_path).to eq(mentor_dashboard_path)

      expect(page).not_to have_link("Switch to Judge mode")
    end

    scenario "a chapter ambassador without a judge profile does not see a judge mode link on their mentor dashboard" do
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved)

      sign_in(chapter_ambassador)

      expect(chapter_ambassador.is_a_judge?).to be_falsey

      click_link "Mentor Mode"
      expect(page).to have_link("Switch to Chapter Ambassador mode")
      expect(current_path).to eq(mentor_dashboard_path)

      expect(page).not_to have_link("Switch to Judge mode")
    end
  end
end
