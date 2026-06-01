require "rails_helper"

RSpec.feature "Chapter Ambassador views scores" do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador, :approved) }

  before do
    sign_in(chapter_ambassador)

    visit(chapter_ambassador_chapter_admin_path)
  end

  context "after scores set to display" do
    before do
      SeasonToggles.display_scores_on!
    end

    scenario "chapter ambassador can't pick finals scores, as there is no such thing" do
      click_link "Scores"
      options = page.find("[name='scored_submissions_grid[round]']").all("option")
      expect(options.map(&:value)).not_to include("finals")
    end

    scenario "can view virtual QF scores" do
      submission = FactoryBot.create(
        :submission,
        :complete
      )

      submission.team.students.each do |student|
        student.chapterable_assignments.destroy_all

        student.chapterable_assignments.create(
          chapterable: chapter_ambassador.chapterable,
          account: student.account,
          season: Season.current.year,
          primary: true
        )
      end

      FactoryBot.create(:submission_score, :complete, team_submission: submission)

      click_link "Scores"
      within_results_page_with("#team_submission_#{submission.id}") do
        find("a.view-details").click
      end

      expect(page).to have_content("View score")
    end

    scenario "can view SF scores" do
      submission = FactoryBot.create(
        :submission,
        :complete,
        :semifinalist
      )

      submission.team.students.each do |student|
        student.chapterable_assignments.destroy_all

        student.chapterable_assignments.create(
          chapterable: chapter_ambassador.chapterable,
          account: student.account,
          season: Season.current.year,
          primary: true
        )
      end

      FactoryBot.create(
        :score,
        :complete,
        round: :semifinals,
        team_submission: submission
      )

      visit chapter_ambassador_scores_path(scored_submissions_grid: {round: :semifinals})
      within_results_page_with("#team_submission_#{submission.id}") do
        find("a.view-details").click
      end

      expect(page).to have_content("View score")
    end

    scenario "can see SF columns and data" do
      submission = FactoryBot.create(
        :submission,
        :complete,
        :semifinalist
      )

      submission.team.students.each do |student|
        student.chapterable_assignments.destroy_all

        student.chapterable_assignments.create(
          chapterable: chapter_ambassador.chapterable,
          account: student.account,
          season: Season.current.year,
          primary: true
        )
      end

      FactoryBot.create(:submission_score, :complete, team_submission: submission)
      FactoryBot.create(
        :score,
        :complete,
        round: :semifinals,
        team_submission: submission
      )

      click_link "Scores"

      expect(page).to have_selector(".semifinals_average")

      within_results_page_with("#team_submission_#{submission.id}") do
        find("a.view-details").click
      end

      expect(page).to have_content("Semifinals average")
    end

    scenario "score drilldown masks judge name and hides judge profile link when judge is not on chapter RPE" do
      submission = FactoryBot.create(:submission, :complete)
      judge = FactoryBot.create(:judge_profile, :brazil, first_name: "Alice")
      judge.account.update!(last_name: "Baker")

      submission.team.students.each do |student|
        student.chapterable_assignments.destroy_all

        student.chapterable_assignments.create(
          chapterable: chapter_ambassador.chapterable,
          account: student.account,
          season: Season.current.year,
          primary: true
        )
      end

      FactoryBot.create(
        :submission_score,
        :complete,
        team_submission: submission,
        judge_profile: judge
      )

      click_link "Scores"
      within_results_page_with("#team_submission_#{submission.id}") do
        find("a.view-details").click
      end

      within "#complete-quarterfinal-scores" do
        expect(page).to have_content("Alice B.")
        expect(page).not_to have_content("Alice Baker")
        expect(page).not_to have_link("Alice B.", href: chapter_ambassador_participant_path(judge.account_id))

        click_link "View score"
      end

      within ".admin-score-header" do
        expect(page).to have_content("Alice B.")
        expect(page).not_to have_content("Alice Baker")
        expect(page).not_to have_link("Alice B.", href: chapter_ambassador_participant_path(judge.account_id))
        expect(page).not_to have_content("Score comes from")

        expect(page).to have_content("Country")
        expect(page).to have_content("Brazil")
        expect(page).not_to have_content("Salvador")
        expect(page).not_to have_content("Bahia")
      end
    end

    scenario "score drilldown allows judge profile link when judge attends chapter RPE" do
      submission = FactoryBot.create(:submission, :complete)
      judge = FactoryBot.create(:judge_profile, :brazil, first_name: "Lina")
      judge.account.update!(last_name: "Carver")
      regional_pitch_event = FactoryBot.create(
        :regional_pitch_event,
        ambassador: chapter_ambassador.chapter_ambassador_profile
      )

      submission.team.students.each do |student|
        student.chapterable_assignments.destroy_all

        student.chapterable_assignments.create(
          chapterable: chapter_ambassador.chapterable,
          account: student.account,
          season: Season.current.year,
          primary: true
        )
      end

      regional_pitch_event.teams << submission.team
      regional_pitch_event.judges << judge

      FactoryBot.create(
        :submission_score,
        :complete,
        :live,
        team_submission: submission,
        judge_profile: judge
      )

      click_link "Scores"
      within_results_page_with("#team_submission_#{submission.id}") do
        find("a.view-details").click
      end

      within "#complete-quarterfinal-scores" do
        expect(page).to have_link("Lina C.", href: chapter_ambassador_participant_path(judge.account_id))
        expect(page).not_to have_content("Lina Carver")

        click_link "View score"
      end

      within ".admin-score-header" do
        expect(page).to have_link("Lina C.", href: chapter_ambassador_participant_path(judge.account_id))
        expect(page).not_to have_content("Score comes from")

        expect(page).to have_content("Country")
        expect(page).to have_content("Brazil")
        expect(page).not_to have_content("Salvador")
        expect(page).not_to have_content("Bahia")
      end
    end
  end

  context "before scores set to display" do
    before do
      SeasonToggles.display_scores_off!
    end

    scenario "can view live QF scores" do
      submission = FactoryBot.create(
        :submission,
        :complete
      )

      submission.team.students.each do |student|
        student.chapterable_assignments.create(
          chapterable: chapter_ambassador.chapterable,
          account: student.account,
          season: Season.current.year,
          primary: true
        )
      end

      FactoryBot.create(:submission_score, :complete, team_submission: submission)

      rpe = FactoryBot.create(:rpe)

      rpe.teams << submission.team

      click_link "Scores"
      within_results_page_with("#team_submission_#{submission.id}") do
        find("a.view-details").click
      end

      expect(page).to have_content("View score")
    end

    scenario "can not view virtual QF scores" do
      submission = FactoryBot.create(
        :submission,
        :complete
      )

      submission.team.students.each do |student|
        student.chapterable_assignments.destroy_all

        student.chapterable_assignments.create(
          chapterable: chapter_ambassador.chapterable,
          account: student.account,
          season: Season.current.year,
          primary: true
        )
      end

      FactoryBot.create(:submission_score, :complete, team_submission: submission)

      click_link "Scores"
      expect(page).to have_no_selector("#team_submission_#{submission.id}")
      expect(page).to have_no_selector(".next_page")
    end

    scenario "can not see SF columns and data" do
      submission = FactoryBot.create(
        :submission,
        :complete,
        :semifinalist
      )

      submission.team.students.each do |student|
        student.chapterable_assignments.destroy_all

        student.chapterable_assignments.create(
          chapterable: chapter_ambassador.chapterable,
          account: student.account,
          season: Season.current.year,
          primary: true
        )
      end

      rpe = FactoryBot.create(:rpe)

      rpe.teams << submission.team

      FactoryBot.create(:submission_score, :complete, team_submission: submission)
      FactoryBot.create(
        :score,
        :complete,
        round: :semifinals,
        team_submission: submission
      )

      click_link "Scores"

      expect(page).to have_no_selector(".semifinals_average")

      within_results_page_with("#team_submission_#{submission.id}") do
        find("a.view-details").click
      end

      expect(page).not_to have_content("Semifinals average")
    end
  end

  scenario "chapter ambassador lacks admin-only extra columns" do
    submission = FactoryBot.create(
      :submission,
      :junior,
      :complete
    )

    submission.team.students.each do |student|
      student.chapterable_assignments.destroy_all

      student.chapterable_assignments.create(
        chapterable: chapter_ambassador.chapterable,
        account: student.account,
        season: Season.current.year,
        primary: true
      )
    end

    FactoryBot.create(
      :submission_score,
      :complete,
      team_submission: submission
    )

    SeasonToggles.judging_round = :qf

    visit chapter_ambassador_scores_path

    expect(page).not_to have_select(
      "More columns",
      with_options: [
        "Team ID",
        "Submission ID"
      ]
    )
  end
end
