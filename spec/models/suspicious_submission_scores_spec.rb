require "rails_helper"

RSpec.describe SuspiciousSubmissionScores do
  before do
    SeasonToggles.judging_round = :qf
  end

  after do
    SeasonToggles.judging_round = :off
  end

  let(:judge) { FactoryBot.create(:judge) }

  context "when a judge completes a 'virtual' score too fast" do
    let(:score) { FactoryBot.create(:score, :virtual, :minimum_auto_approved_total, judge_profile: judge) }

    before do
      score.complete!
    end

    it "marks it as being completed too fast" do
      expect(score.completed_too_fast?).to eq(true)
    end
  end

  context "when a judge gives a low score to a 'virtual' score" do
    let(:score) { FactoryBot.create(:score, :virtual, :minimum_auto_approved_total, judge_profile: judge) }

    before do
      score.update({ideation_1: 0, ideation_2: 0, pitch_1: 0, pitch_2: 0})
      score.complete!
    end

    it "marks it as being scored too low" do
      expect(score.seems_too_low?).to eq(true)
    end
  end

  context "when a judge completes a 'live' score too fast" do
    let(:score) { FactoryBot.create(:score, :live, :minimum_auto_approved_total, judge_profile: judge) }

    before do
      score.complete!
    end

    it "does not mark it as being completed too fast" do
      expect(score.completed_too_fast?).to eq(false)
      expect(SuspiciousSubmissionScores.new.scores).to be_empty
    end
  end

  context "when a judge gives a low score to a 'live' score" do
    let(:score) { FactoryBot.create(:score, :live, :minimum_auto_approved_total, judge_profile: judge) }

    before do
      score.update({ideation_1: 0, ideation_2: 0, pitch_1: 0, pitch_2: 0})
      score.complete!
    end

    it "does not mark it as being scored too low" do
      expect(score.seems_too_low?).to eq(false)
      expect(SuspiciousSubmissionScores.new.scores).to be_empty
    end
  end

  describe "when same judge completes 2 scores too fast" do
    it "includes those scores" do
      judge = FactoryBot.create(:judge)
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

  describe "when scores are too low" do
    let(:senior_low_score) { FactoryBot.create(:score, :senior) }
    let(:junior_low_score) { FactoryBot.create(:score, :junior) }
    let(:beginner_low_score) { FactoryBot.create(:score, :beginner) }
    let(:normal_score) { FactoryBot.create(:score, :minimum_auto_approved_total) }

    before do
      senior_low_score.update({ideation_1: 24})
      junior_low_score.update({ideation_1: 19})
      beginner_low_score.update({ideation_1: 14})

      SubmissionScore.find_each(&:complete!)
    end

    it "includes all of the low scores" do
      expect(
        SuspiciousSubmissionScores.new.map(&:id)
      ).to contain_exactly(
        senior_low_score.id,
        junior_low_score.id,
        beginner_low_score.id
      )
    end
  end
end
