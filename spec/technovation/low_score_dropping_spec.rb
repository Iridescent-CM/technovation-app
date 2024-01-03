require "rails_helper"

RSpec.describe LowScoreDropping do
  [:quarterfinals, :semifinals].each do |current_round|
    context "within #{current_round}" do
      before { set_judging_round(current_round) }
      after { reset_judging_round }

      let(:submission) { FactoryBot.create(:submission, :complete) }
      let!(:low_score) {
        FactoryBot.create(
          :score,
          :complete,
          team_submission: submission,
          ideation_1: 1,
          round: round
        )
      }
      let!(:middle_score) {
        FactoryBot.create(
          :score,
          :complete,
          team_submission: submission,
          ideation_1: 3,
          round: round
        )
      }
      let!(:high_score) {
        FactoryBot.create(
          :score,
          :complete,
          team_submission: submission,
          ideation_1: 5,
          round: round
        )
      }
      let(:dropper) {
        LowScoreDropping.new(
          submission,
          round: round,
          minimum_score_count: minimum_score_count
        )
      }
      let(:round) { current_round }
      let(:minimum_score_count) { 1 }

      it "detects when a score has already been dropped" do
        low_score.drop_score!

        expect(dropper).to be_already_dropped
      end

      context "with a higher score count" do
        let(:minimum_score_count) { 4 }

        it "doesn't have enough scores" do
          expect(dropper).not_to have_enough_scores
        end

        it "does not drop the lowest score" do
          dropper.drop!
          expect(low_score.reload).not_to be_dropped
        end
      end

      it "identifies the lowest score" do
        expect(dropper.lowest_score).to eq(low_score)
      end

      it "gets the current score average" do
        expect(dropper.average).to eq(3)
        low_score.drop_score!
        expect(dropper.average).to eq(4)
      end

      it "drops the lowest score when able" do
        dropper.drop!
        expect(low_score.reload).to be_dropped
      end

      it "only drops the lowest score once per submission" do
        dropper.drop!
        dropper.drop!
        dropper.drop!
        expect(low_score.reload).to be_dropped
        expect(middle_score.reload).not_to be_dropped
        expect(high_score.reload).not_to be_dropped
      end
    end
  end

  context "across both rounds" do
    let(:submission) { FactoryBot.create(:submission, :complete) }
    let!(:qf_score) {
      FactoryBot.create(
        :score,
        :complete,
        team_submission: submission,
        ideation_1: 1,
        round: :quarterfinals
      )
    }
    let!(:sf_score) {
      FactoryBot.create(
        :score,
        :complete,
        team_submission: submission,
        ideation_1: 3,
        round: :semifinals
      )
    }
    let(:qf_dropper) {
      LowScoreDropping.new(
        submission,
        round: :quarterfinals,
        minimum_score_count: 1
      )
    }
    let(:sf_dropper) {
      LowScoreDropping.new(
        submission,
        round: :semifinals,
        minimum_score_count: 1
      )
    }

    it "allows score to be dropped from each round" do
      qf_dropper.drop!
      sf_dropper.drop!
      expect(qf_score.reload).to be_dropped
      expect(sf_score.reload).to be_dropped
    end
  end
end
