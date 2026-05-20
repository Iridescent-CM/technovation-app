require "rails_helper"

feature "club ambassadors switch to judge mode from club ambassador dashboard", :js do
  # `CreateJudgeProfile` (and the factory's `:has_judge_profile` trait) doesn't
  # cover club ambassadors today; admins set this up manually via the admin UI
  # (see #5581). Mirror that by creating the judge profile directly on the
  # account.
  def give_judge_profile(club_ambassador)
    club_ambassador.account.create_judge_profile!(
      company_name: "FactoryBot",
      job_title: "Engineer"
    )
    club_ambassador.account.reload
    club_ambassador
  end

  feature "with config on" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_CHAPTER_AMBASSADOR_SWITCH_TO_JUDGE", any_args).and_return(true)
    end

    scenario "a club ambassador with a judge profile can reach the judge dashboard" do
      club_ambassador = give_judge_profile(FactoryBot.create(:club_ambassador))

      sign_in(club_ambassador)

      expect(club_ambassador.is_a_judge?).to be_truthy

      visit judge_dashboard_path
      expect(current_path).to eq(judge_dashboard_path)
      expect(page).to have_text("Judging Rubric")
    end

    scenario "a club ambassador without a judge profile does not see a judge mode link" do
      club_ambassador = FactoryBot.create(:club_ambassador)

      sign_in(club_ambassador)

      expect(club_ambassador.is_a_judge?).to be_falsey

      expect(page).not_to have_link("Judge Mode")
    end

    scenario "club ambassadors without a judge profile cannot browse to judge dashboard" do
      club_ambassador = FactoryBot.create(:club_ambassador)

      sign_in(club_ambassador)

      visit judge_dashboard_path

      expect(current_path).to eq(club_ambassador_dashboard_path)
      expect(page).to have_content("You don't have permission to go there!")
    end
  end

  feature "with config off" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ENABLE_CHAPTER_AMBASSADOR_SWITCH_TO_JUDGE", any_args).and_return(false)
    end

    scenario "club ambassadors with a judge profile do not see judge mode link" do
      club_ambassador = give_judge_profile(FactoryBot.create(:club_ambassador))

      sign_in(club_ambassador)

      expect(club_ambassador.is_a_judge?).to be_truthy
      expect(current_path).to eq(club_ambassador_dashboard_path)

      expect(page).not_to have_link("Judge Mode")
    end

    scenario "club ambassadors without a judge profile do not see a judge mode link" do
      club_ambassador = FactoryBot.create(:club_ambassador)

      sign_in(club_ambassador)

      expect(club_ambassador.is_a_judge?).to be_falsey
      expect(current_path).to eq(club_ambassador_dashboard_path)

      expect(page).not_to have_link("Judge Mode")
    end

    scenario "club ambassadors with a judge profile cannot reach the judge dashboard by URL" do
      club_ambassador = give_judge_profile(FactoryBot.create(:club_ambassador))

      sign_in(club_ambassador)

      visit judge_dashboard_path

      expect(current_path).to eq(club_ambassador_dashboard_path)
      expect(page).to have_content("You don't have permission to go there!")
    end
  end
end
