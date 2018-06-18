class BadgeRecipient
  attr_reader :judge, :scores

  def initialize(judge)
    @judge = judge
    @scores = judge.current_completed_scores
  end

  def icon_name
    if !!judge.override_certificate_type
      CERTIFICATE_TYPES[judge.override_certificate_type].gsub("_", "-")
    elsif scores.any? && scores.count <= MAXIMUM_SCORES_FOR_GENERAL_JUDGE
      "general-judge"
    elsif scores.any? && scores.count == NUMBER_OF_SCORES_FOR_CERTIFIED_JUDGE
      "certified-judge"
    elsif scores.count <= MAXIMUM_SCORES_FOR_HEAD_JUDGE &&
            (judge.events.any? || scores.count >= MINIMUM_SCORES_FOR_HEAD_JUDGE)
      "head-judge"
    elsif scores.count >= MINIMUM_SCORES_FOR_JUDGE_ADVISOR
      "judge-advisor"
    end
  end

  def name
    icon_name.humanize.titleize
  end
end