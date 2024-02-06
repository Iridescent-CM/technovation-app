require "rails_helper"

RSpec.describe "viewing score details page" do
  let!(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador, :approved, :chicago) }
  let!(:team) { FactoryBot.create(:team, :chicago, :senior, name: "Ravenclaw") }
  let!(:team_submission) {
    FactoryBot.create(:team_submission,
      :complete,
      :semifinalist,
      :chicago,
      team: team)
  }
  let!(:complete_quarterfinal_score) {
    FactoryBot.create(:score,
      :complete,
      :quarterfinals,
      :minimum_auto_approved_total,
      :approved,
      :chicago,
      team_submission: team_submission)
  }
  let!(:incomplete_quarterfinal_score) {
    FactoryBot.create(:score,
      :incomplete,
      :quarterfinals,
      :minimum_auto_approved_total,
      :approved,
      :chicago,
      team_submission: team_submission)
  }
  let!(:complete_semifinal_score) {
    FactoryBot.create(:score,
      :complete,
      :semifinals,
      :minimum_auto_approved_total,
      :approved,
      :chicago,
      team_submission: team_submission)
  }
  let!(:incomplete_semifinal_score) {
    FactoryBot.create(:score,
      :incomplete,
      :semifinals,
      :minimum_auto_approved_total,
      :approved,
      :chicago,
      team_submission: team_submission)
  }

  context "when the 'display_scores' setting is turned off" do
    before do
      SeasonToggles.display_scores_off!
    end

    context "when the team has attended an RPE" do
      let!(:live_regional_pitch_event) { FactoryBot.create(:regional_pitch_event, :chicago, name: "Windy City Event", ambassador: chapter_ambassador) }

      before do
        live_regional_pitch_event.teams << team
      end

      context "when the chapter ambassador views the main scores page" do
        before do
          sign_in(chapter_ambassador)

          click_link "Scores"
        end

        it "displays the team who attended the RPE" do
          expect(page).to have_content("Ravenclaw")
          expect(page).to have_css("#team_submission_#{team_submission.id}")
        end
      end

      context "when the chapter ambassador views the score details page for the team who attended the RPE" do
        before do
          sign_in(chapter_ambassador)

          click_link "Scores"
          within "#team_submission_#{team_submission.id}" do
            find("a.view-details").click
          end
        end

        it "displays the team's name" do
          within "h1" do
            expect(page).to have_content("Ravenclaw")
          end
        end

        it "displays the team's rank" do
          expect(page).to have_content("semifinalist")
        end

        it "displays the name of the RPE" do
          expect(page).to have_content("Windy City Event")
        end

        it "displays complete quarterfinal scores" do
          within "#complete-quarterfinal-scores" do
            expect(page).to have_content("30 / 80")
            expect(page).to have_content("View score")
          end
        end

        it "displays incomplete quarterfinal scores" do
          within "#incomplete-quarterfinal-scores" do
            expect(page).to have_content("30 / 80")
            expect(page).to have_content("View score")
          end
        end

        it "does not display complete semifinal scores" do
          expect(page).not_to have_css("#complete-semifinal-scores")
        end

        it "does not display incomplete semifinal scores" do
          expect(page).not_to have_css("#incomplete-semifinal-scores")
        end
      end

      context "when a score has been deleted" do
        before do
          complete_quarterfinal_score.destroy
        end

        context "when the chapter ambassador views the score details page for the team who attended the RPE" do
          before do
            sign_in(chapter_ambassador)

            click_link "Scores"
            within "#team_submission_#{team_submission.id}" do
              find("a.view-details").click
            end
          end

          it "does not display the deleted score" do
            within "#complete-quarterfinal-scores" do
              expect(page).not_to have_content("20 / 60")
              expect(page).not_to have_content("View score")

              expect(page).to have_content("No scores")
            end
          end
        end
      end
    end

    context "when the team has not attended an RPE" do
      context "when the chapter ambassador views the main scores page" do
        before do
          sign_in(chapter_ambassador)

          click_link "Scores"
        end

        it "does not display the team" do
          expect(page).not_to have_content("Ravenclaw")
          expect(page).not_to have_css("#team_submission_#{team_submission.id}")
        end
      end
    end
  end

  context "when the 'display_scores' setting is turned on" do
    before do
      SeasonToggles.display_scores_on!
    end

    context "when the chapter ambassador views the main scores page" do
      before do
        sign_in(chapter_ambassador)

        click_link "Scores"
      end

      it "displays the team (regardless if they attended an RPE or not)" do
        expect(page).to have_content("Ravenclaw")
        expect(page).to have_css("#team_submission_#{team_submission.id}")
      end
    end

    context "when the chapter ambassador views the score details page for the team" do
      before do
        sign_in(chapter_ambassador)

        click_link "Scores"
        within "#team_submission_#{team_submission.id}" do
          find("a.view-details").click
        end
      end

      it "displays the team's name" do
        within "h1" do
          expect(page).to have_content("Ravenclaw")
        end
      end

      it "displays the team's rank" do
        expect(page).to have_content("semifinalist")
      end

      it "displays the name of the RPE" do
        expect(page).to have_content("Online Judging")
      end

      it "displays complete quarterfinal scores" do
        within "#complete-quarterfinal-scores" do
          expect(page).to have_content("30 / 80")
          expect(page).to have_content("View score")
        end
      end

      it "displays incomplete quarterfinal scores" do
        within "#incomplete-quarterfinal-scores" do
          expect(page).to have_content("30 / 80")
          expect(page).to have_content("View score")
        end
      end

      it "displays complete semifinal scores" do
        within "#complete-semifinal-scores" do
          expect(page).to have_content("30 / 80")
          expect(page).to have_content("View score")
        end
      end

      it "displays incomplete semifinal scores" do
        within "#incomplete-semifinal-scores" do
          expect(page).to have_content("30 / 80")
          expect(page).to have_content("View score")
        end
      end
    end

    context "when a score has been deleted" do
      before do
        complete_quarterfinal_score.destroy
      end

      context "when the chapter ambassador views the score details page for that team" do
        before do
          sign_in(chapter_ambassador)

          click_link "Scores"
          within "#team_submission_#{team_submission.id}" do
            find("a.view-details").click
          end
        end

        it "does not display the deleted score" do
          within "#complete-quarterfinal-scores" do
            expect(page).not_to have_content("20 / 60")
            expect(page).not_to have_content("View score")

            expect(page).to have_content("No scores")
          end
        end
      end
    end
  end
end
