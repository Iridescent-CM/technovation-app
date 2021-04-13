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

        judge = FactoryBot.create(:judge, :onboarded)

        sign_in(judge)

        expect {
          request.accept = "application/json"
          get :new
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

        judge = FactoryBot.create(:judge, :onboarded)

        sign_in(judge)

        expect {
          request.accept = "application/json"
          get :new
        }.to change { judge.scores.current_round.count }.from(0).to(1)
        .and change { submission.reload.submission_scores_count }.from(nil).to(1)
      end
    end

    context "suspended judge" do
      before { set_judging_round(:QF) }
      after { reset_judging_round }

      it "prevents score" do
        team = FactoryBot.create(:team)

        submission = FactoryBot.create(
          :submission,
          :complete,
          contest_rank: :quarterfinalist,
          team: team
        )

        judge = FactoryBot.create(:judge, :onboarded, suspended: true)

        sign_in(judge)

        request.accept = "application/json"
        get :new

        expect(response.status).to eq(403)
        expect(judge.scores.current_round.count).to eq(0)
      end
    end

    %w{off between finished}.each do |round|
      context round.titleize do
        it "prevents score" do
          team = FactoryBot.create(:team)

          submission = FactoryBot.create(
            :submission,
            :complete,
            contest_rank: :quarterfinalist,
            team: team
          )

          judge = FactoryBot.create(:judge, :onboarded)

          sign_in(judge)

          request.accept = "application/json"
          get :new

          expect(response.status).to eq(404)
          expect(judge.scores.current_round.count).to eq(0)
        end
      end
    end
  end

  describe "GET #edit" do
    %w{between finished}.each do |round|
      context round.titleize do
        it "prevents virtual score edits" do
          team = FactoryBot.create(:team)

          submission = FactoryBot.create(
            :submission,
            :complete,
            contest_rank: :quarterfinalist,
            team: team
          )

          judge = FactoryBot.create(:judge, :onboarded)

          score = judge.submission_scores.create!({
            team_submission: submission
          })

          sign_in(judge)

          request.accept = "application/json"
          patch :update, params: {
            id: score.id,
            submission_score: {
              pitch_specific: 2
            }
          }

          expect(response.status).to eq(404)
          expect(score.reload.total).to eq(0)
        end

        it "prevents live score edits" do
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

          request.accept = "application/json"
          patch :update, params: {
            id: score.id,
            submission_score: {
              pitch_specific: 2
            }
          }

          expect(response.status).to eq(404)
          expect(score.reload.total).to eq(0)
        end
      end

      context "suspended judge" do
        before { set_judging_round(:QF) }
        after { reset_judging_round }

        it "prevents virtual score edits" do
          team = FactoryBot.create(:team)

          submission = FactoryBot.create(
            :submission,
            :complete,
            contest_rank: :quarterfinalist,
            team: team
          )

          judge = FactoryBot.create(:judge, :onboarded, suspended: true)

          score = judge.submission_scores.create!({
            team_submission: submission
          })

          sign_in(judge)

          request.accept = "application/json"
          patch :update, params: {
            id: score.id,
            submission_score: {
              pitch_specific: 2
            }
          }

          expect(response.status).to eq(403)
          expect(score.reload.total).to eq(0)
        end

        it "prevents live score edits" do
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

          judge = FactoryBot.create(:judge, :onboarded, suspended: true)

          judge.regional_pitch_events << rpe
          judge.save

          score = judge.submission_scores.create!({
            team_submission: submission
          })

          sign_in(judge)

          request.accept = "application/json"
          patch :update, params: {
            id: score.id,
            submission_score: {
              pitch_specific: 2
            }
          }

          expect(response.status).to eq(403)
          expect(score.reload.total).to eq(0)
        end
      end
    end
  end

  describe "PATCH #judge recusal" do
    let(:judge) { FactoryBot.create(:judge, :onboarded, suspended: true) }
    let(:team) { FactoryBot.create(:team) }
    let(:submission) do
      FactoryBot.create(
        :submission,
        :complete,
        contest_rank: :quarterfinalist,
        team: team
      )
    end
    let(:score) do
      judge.submission_scores.create!({
        team_submission: submission
      })
    end

    before do
      set_judging_round(:QF)
      sign_in(judge)

      patch :judge_recusal, params: {
        score_id: score.id,
        submission_score: {
          judge_recusal_reason: "other",
          judge_recusal_comment: "Wakarimasen"
        }
      }
    end

    after { reset_judging_round }

    it "saves the recusal reason and comment" do
      expect(score.reload.judge_recusal_reason).to eq("other")
      expect(score.reload.judge_recusal_comment).to eq("Wakarimasen")
    end

    it "sets the judge recusal flag" do
      expect(score.reload.judge_recusal).to eq(true)
    end
  end
end
