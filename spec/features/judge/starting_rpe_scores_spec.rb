require "rails_helper"

RSpec.feature "starting RPE scores", js: true do
  let(:judge) { FactoryBot.create(:judge, :onboarded) }

  context "as an onboarded judge that is registered for an RPE and that RPE has 1 submission" do
    before do
      @rpe = FactoryBot.create(:rpe)
      @submission = FactoryBot.create(:team_submission, :junior, :complete)
      @submission.team.regional_pitch_events << @rpe
      judge.regional_pitch_events << @rpe
    end

    scenario "Judging is set to off" do
      SeasonToggles.judging_round = :off

      sign_in(judge)
      expect(page).to have_content("Welcome to the online judging portal!")
      expect(page).to have_content("You will be judging teams at the following event(s).")
    end

    scenario "Judging is set to qf" do
      SeasonToggles.judging_round = :qf

      sign_in(judge)
      click_link "Judge Submissions"

      expect(page).to have_content("Begin scoring your assigned submissions.")
      expect(page).to have_content("SUBMISSIONS TO SCORE")
      expect(page).to have_link "Start"

      click_link "Start"

      expect(page).to have_content(@submission.team_name)
      expect(page).to have_content(@submission.development_platform)
      expect(page).to have_link "Start Score"
    end
  end

  context "as an onboarded judge that is registered for an RPE and that RPE has multiple submissions" do
    before do
      @rpe = FactoryBot.create(:rpe)
      @submissions = FactoryBot.create_list(:team_submission, 3, :junior, :complete)
      @submissions.each do |sub|
        sub.team.regional_pitch_events << @rpe
      end
      judge.regional_pitch_events << @rpe
    end

    scenario "Judge does not see an incomplete submission" do
      @incomplete_submission = FactoryBot.create(:team_submission, :junior, :incomplete)
      @incomplete_submission.team.regional_pitch_events << @rpe

      SeasonToggles.judging_round = :qf
      sign_in(judge)
      click_link "Judge Submissions"

      expect(page).not_to have_content(@incomplete_submission.app_name)
    end

    scenario "Judging is set to qf and the judge can see all the start buttons for all assigned submissions that have not been started" do
      SeasonToggles.judging_round = :qf

      sign_in(judge)
      click_link "Judge Submissions"

      expect(page).to have_content("Begin scoring your assigned submissions.")
      expect(page).to have_content("SUBMISSIONS TO SCORE")
      expect(page).to have_link "Start", count: @submissions.count
    end

    scenario "the judge has a score in progress" do
      score = FactoryBot.create(:score,
        :incomplete,
        :quarterfinals,
        judge_profile: judge,
        team_submission: @submissions[0])
      SeasonToggles.judging_round = :qf

      sign_in(judge)
      click_link "Judge Submissions"

      expect(page).to have_content("Begin scoring your assigned submissions.")
      expect(page).to have_content("YOUR SCORE IN PROGRESS")
      expect(page).to have_link "Resume", count: 1
    end
  end
end
