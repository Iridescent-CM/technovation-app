require "rails_helper"

RSpec.describe SuspiciousSubmissionScores do
  before do
    SeasonToggles.judging_round = :qf
  end

  after do
    SeasonToggles.judging_round = :off
  end

  describe "when same judge completes 2 scores too fast" do
    it "includes those scores" do
      judge  = FactoryBot.create(:judge)
      score = FactoryBot.create(:score, :minimum_auto_approved_total, judge_profile: judge)
      score2 = FactoryBot.create(:score, :minimum_auto_approved_total, judge_profile: judge)
      score3 = FactoryBot.create(:score, :minimum_auto_approved_total, judge_profile: judge)

      score.complete!
      expect(score).to be_completed_too_fast
      expect(score).not_to be_completed_too_fast_repeat_offense
      expect(score).to be_approved
      expect(SuspiciousSubmissionScores.new.scores).to be_empty

      Timecop.travel(10.minutes.from_now) do
        score2.complete!
        expect(score2.reload).not_to be_completed_too_fast
        expect(score2).not_to be_completed_too_fast_repeat_offense
        expect(score2).to be_approved
        expect(SuspiciousSubmissionScores.new.scores).to be_empty
      end

      score3.complete!
      expect(score3.reload).to be_completed_too_fast
      expect(score3).to be_completed_too_fast_repeat_offense
      expect(score3).not_to be_approved

      suspicious = SuspiciousSubmissionScores.new
      expect(suspicious.map(&:id)).to eq([score3.id])
    end
  end

  describe "when score is too low" do
    it "includes those scores" do
      senior_min_score, senior_low_score, junior_low_score, junior_min_score = nil

      Timecop.freeze(10.minutes.ago) do
        senior_min_score = FactoryBot.create(:score, :senior)
        junior_min_score = FactoryBot.create(:score, :junior)

        senior_low_score = FactoryBot.create(:score, :senior)
        junior_low_score = FactoryBot.create(:score, :junior)
      end

      senior_min_score.update({
        pitch_1: 5,
        pitch_2: 5,
        pitch_3: 5,
        pitch_4: 5
      })

      junior_min_score.update({
        pitch_1: 5,
        pitch_2: 5,
        pitch_3: 5,
        pitch_4: 5
      })

      senior_low_score.update({
        ideation_1: 1,
        ideation_2: 1,
        pitch_1: 1,
        pitch_2: 1,
        entrepreneurship_1: 1,
        entrepreneurship_2: 1
      })

      junior_low_score.update({
        ideation_1: 1,
        ideation_2: 1,
        pitch_1: 1,
        pitch_2: 1,
        entrepreneurship_1: 1,
        entrepreneurship_2: 1
      })

      SubmissionScore.find_each(&:complete!)

      suspicious = SuspiciousSubmissionScores.new
      expect(suspicious.map(&:id)).to contain_exactly(
        senior_low_score.id,
        junior_low_score.id
      )
    end
  end
end
