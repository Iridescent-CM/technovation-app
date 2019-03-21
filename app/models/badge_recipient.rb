require "./app/constants/badge_levels"

class BadgeRecipient
  attr_reader :judge, :scores, :season

  def initialize(judge, **options)
    @judge = judge
    @season = options.fetch(:season) { Season.current.year }
    @scores = judge.completed_scores.by_season(season)
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
    else
      ""
    end
  end

  def name
    icon_name.humanize.titleize
  end

  def valid?
    not icon_name.blank?
  end
end