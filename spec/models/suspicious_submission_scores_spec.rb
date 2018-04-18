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
      expect(SeasonToggles).to be_quarterfinals_judging

      judge  = FactoryBot.create(:judge)
      score = FactoryBot.create(:score, judge_profile: judge)
      score2 = FactoryBot.create(:score, judge_profile: judge)
      score3 = FactoryBot.create(:score, judge_profile: judge)

      score.complete!
      expect(score).to be_completed_too_fast
      expect(score).not_to be_completed_too_fast_repeat_offense
      expect(SuspiciousSubmissionScores.new.scores).to be_empty

      Timecop.travel(10.minutes.from_now) do
        score2.complete!
        expect(score2.reload).not_to be_completed_too_fast
        expect(SuspiciousSubmissionScores.new.scores).to be_empty
      end

      score3.complete!
      expect(score3.reload).to be_completed_too_fast
      expect(score3).to be_completed_too_fast_repeat_offense

      suspicious = SuspiciousSubmissionScores.new
      expect(suspicious.map(&:id)).to eq([score3.id])
    end
  end
end