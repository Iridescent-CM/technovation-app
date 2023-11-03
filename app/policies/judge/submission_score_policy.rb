module Judge
  class SubmissionScorePolicy < ApplicationPolicy
    def new?
      current_account.judge_profile.present? &&
        current_account.judge_profile.scores.map(&:id).include?(record.id)
    end
  end
end
