require "rails_helper"

RSpec.describe Judge::ScoresController do
  describe "GET #new" do
    %w{QF SF}.each do |round|
      context round do
        before { set_judging_round(round) }
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

          now = Time.current
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
    end
  end
end
