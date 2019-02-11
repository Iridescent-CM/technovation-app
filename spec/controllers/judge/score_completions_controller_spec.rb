require "rails_helper"

RSpec.describe Judge::ScoreCompletionsController do
  describe "POST #create" do
    context "QF" do
      before { set_judging_round(:QF) }
      after { reset_judging_round }

      it "completes live score before live deadline" do
        team = FactoryBot.create(:team)

        submission = FactoryBot.create(
          :submission,
          :complete,
          contest_rank: :quarterfinalist,
          team: team
        )

        rpe = FactoryBot.create(:event,
          name: "RPE",
          starts_at: Date.today,
          ends_at: Date.today + 1.day,
          division_ids: Division.senior.id,
          city: "City",
          venue_address: "123 Street St.",
          unofficial: false,
        )

        team.regional_pitch_events << rpe
        team.save

        now = ImportantDates.virtual_quarterfinals_judging_ends - 1.days
        judge = FactoryBot.create(:judge, :onboarded)

        judge.regional_pitch_events << rpe
        judge.save

        score = judge.submission_scores.create!({
          team_submission: submission
        })

        sign_in(judge)

        Timecop.freeze(now) {
          post :create, params: {
            id: score.id
          }

          expect(score.reload).to be_complete
        }
      end

      it "prevents completion of live score after live deadline" do
        team = FactoryBot.create(:team)

        submission = FactoryBot.create(
          :submission,
          :complete,
          contest_rank: :quarterfinalist,
          team: team
        )

        rpe = FactoryBot.create(:event,
          name: "RPE",
          starts_at: Date.today,
          ends_at: Date.today + 1.day,
          division_ids: Division.senior.id,
          city: "City",
          venue_address: "123 Street St.",
          unofficial: false,
        )

        team.regional_pitch_events << rpe
        team.save

        now = ImportantDates.virtual_quarterfinals_judging_ends + 1.days
        judge = FactoryBot.create(:judge, :onboarded)

        judge.regional_pitch_events << rpe
        judge.save

        score = judge.submission_scores.create!({
          team_submission: submission
        })

        sign_in(judge)

        Timecop.freeze(now) {
          post :create, params: {
            id: score.id
          }

          expect(score.reload).to be_complete
        }
      end

      it "completes virtual score before virtual deadline" do
        team = FactoryBot.create(:team)

        submission = FactoryBot.create(
          :submission,
          :complete,
          contest_rank: :quarterfinalist,
          team: team
        )

        now = ImportantDates.virtual_quarterfinals_judging_ends - 1.days
        judge = FactoryBot.create(:judge, :onboarded)

        score = judge.submission_scores.create!({
          team_submission: submission
        })

        sign_in(judge)

        Timecop.freeze(now) {
          post :create, params: {
            id: score.id
          }

          expect(score.reload).to be_complete
        }
      end

      it "prevents completion of virtual score after virtual deadline" do
        team = FactoryBot.create(:team)

        submission = FactoryBot.create(
          :submission,
          :complete,
          contest_rank: :quarterfinalist,
          team: team
        )

        now = ImportantDates.virtual_quarterfinals_judging_ends + 1.days
        judge = FactoryBot.create(:judge, :onboarded)

        score = judge.submission_scores.create!({
          team_submission: submission
        })

        sign_in(judge)

        Timecop.freeze(now) {
          post :create, params: {
            id: score.id
          }

          expect(score.reload).not_to be_complete
        }
      end
    end
  end
end
