require "rails_helper"

RSpec.describe Judge::ScoresController do
  describe "GET #new" do
    context "SF" do
      before { set_judging_round(:SF) }
      after { reset_judging_round }

      it "sets up a score as opened by the judge at current time" do
        current_rank = :semifinalist

        team = FactoryBot.create(:team)

        submission = FactoryBot.create(
          :submission,
          :complete,
          contest_rank: current_rank,
          team: team
        )

        now = ImportantDates.semifinals_judging_begins + 1
        judge = FactoryBot.create(:judge, :onboarded)

        sign_in(judge)

        expect {
          Timecop.freeze(now) {
            request.accept = "application/json"
            get :new
          }
        }.to change { judge.scores.current_round.count }.from(0).to(1)
        .and change { submission.reload.submission_scores_count }.from(nil).to(1)
      end
    end

    context "virtual QF" do
      before { set_judging_round(:QF) }
      after { reset_judging_round }

      it "sets up a score as opened by the judge at current time" do
        current_rank = if SeasonToggles.semifinals?
                        :semifinalist
                      else
                        :quarterfinalist
                      end

        team = FactoryBot.create(:team)

        submission = FactoryBot.create(
          :submission,
          :complete,
          contest_rank: current_rank,
          team: team
        )

        now = ImportantDates.virtual_quarterfinals_judging_ends - 1
        judge = FactoryBot.create(:judge, :onboarded)

        sign_in(judge)

        expect {
          Timecop.freeze(now) {
            request.accept = "application/json"
            get :new
          }
        }.to change { judge.scores.current_round.count }.from(0).to(1)
        .and change { submission.reload.submission_scores_count }.from(nil).to(1)
      end

      it "prevents virtual score after virtual deadline" do
        team = FactoryBot.create(:team)

        submission = FactoryBot.create(
          :submission,
          :complete,
          contest_rank: :quarterfinalist,
          team: team
        )

        now = ImportantDates.virtual_quarterfinals_judging_ends + 1.days
        judge = FactoryBot.create(:judge, :onboarded)

        sign_in(judge)

        Timecop.freeze(now) {
          request.accept = "application/json"
          get :new

          expect(response.status).to eq(404)
          expect(judge.scores.current_round.count).to eq(0)
        }
      end
    end
  end

  describe "GET #edit" do
    context "QF" do
      it "prevents virtual score edits after virtual deadline" do
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
          request.accept = "application/json"
          patch :update, params: {
            id: score.id, 
            submission_score: {
              pitch_specific: 2
            }
          }

          expect(response.status).to eq(404)
          expect(score.reload.total).to eq(0)
        }
      end

      it "prevents live score edits after live deadline" do
        now = ImportantDates.live_quarterfinals_judging_ends + 1

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

        judge = FactoryBot.create(:judge, :onboarded)

        judge.regional_pitch_events << rpe
        judge.save

        score = judge.submission_scores.create!({
          team_submission: submission
        })

        sign_in(judge)

        Timecop.freeze(now) {
          request.accept = "application/json"
          patch :update, params: {
            id: score.id, 
            submission_score: {
              pitch_specific: 2
            }
          }

          expect(response.status).to eq(404)
          expect(score.reload.total).to eq(0)
        }
      end
    end
  end
end
