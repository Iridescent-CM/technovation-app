module Judging
  class SetContestRank
    def initialize(rank:, submission_ids:)
      @rank = rank
      @submission_ids = submission_ids
    end

    def call
      TeamSubmission.current.where(id: submission_ids).update_all(contest_rank: rank)
    end

    private

    attr_reader :rank, :submission_ids
  end
end
