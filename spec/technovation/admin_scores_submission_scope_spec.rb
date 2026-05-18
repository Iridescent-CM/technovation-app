require "rails_helper"

RSpec.describe AdminScoresSubmissionScope do
  describe ".call" do
    let!(:virtual_submission) {
      FactoryBot.create(
        :team_submission,
        :complete,
        complete_quarterfinals_official_submission_scores_count: 2
      )
    }

    let!(:virtual_submission_with_enough_scores) {
      FactoryBot.create(
        :team_submission,
        :complete,
        complete_quarterfinals_official_submission_scores_count: 3
      )
    }

    let!(:live_submission) {
      submission = FactoryBot.create(
        :team_submission,
        :complete,
        complete_quarterfinals_official_submission_scores_count: 2
      )
      event = FactoryBot.create(:regional_pitch_event, unofficial: false)
      submission.team.events << event
      submission
    }

    it "returns virtual submissions with fewer than 3 complete official quarterfinal scores" do
      results = described_class.call(
        TeamSubmission.complete.current,
        round: "quarterfinals"
      )

      expect(results).to include(virtual_submission)
      expect(results).not_to include(virtual_submission_with_enough_scores)
      expect(results).not_to include(live_submission)
    end

    it "does not apply the complete score limit during semifinals" do
      virtual_submission.update!(
        complete_semifinals_official_submission_scores_count: 5
      )
      virtual_submission_with_enough_scores.update!(
        complete_semifinals_official_submission_scores_count: 5
      )

      results = described_class.call(
        TeamSubmission.complete.current,
        round: "semifinals"
      )

      expect(results).to include(virtual_submission)
      expect(results).to include(virtual_submission_with_enough_scores)
      expect(results).to include(live_submission)
    end
  end

  describe ".resolve_round" do
    it "uses the passed round when present" do
      round = described_class.resolve_round(
        scored_submissions_grid: {round: "semifinals"}
      )

      expect(round).to eq("semifinals")
    end

    it "defaults to quarterfinals when judging is in quarterfinals" do
      SeasonToggles.judging_round = :qf

      round = described_class.resolve_round({})

      expect(round).to eq("quarterfinals")
    end

    it "defaults to semifinals when judging is in semifinals" do
      SeasonToggles.judging_round = :sf

      round = described_class.resolve_round({})

      expect(round).to eq("semifinals")
    end
  end
end
