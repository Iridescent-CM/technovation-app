require "./app/constants/badge_levels"

module DisplayCertificates
  def self.for(judge)
    SeasonToggles.display_scores? &&
      (judge.current_complete_scores.count >= NUMBER_OF_SCORES_FOR_CERTIFIED_JUDGE ||
        judge.current_judge_certificates.any?)
  end
end