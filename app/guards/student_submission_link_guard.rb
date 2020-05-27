class StudentSubmissionLinkGuard
  attr_accessor :team, :student, :season_toggles

  def initialize(team:, student:, season_toggles: SeasonToggles)
    @team           = team
    @student        = student
    @season_toggles = season_toggles
  end

  def display_link_to_new?
    season_toggles.team_submissions_editable? && student.is_on_team? && team.submission.blank?
  end

  def display_link_to_in_progress?
    student.is_on_team? && team.submission.present?
  end

  def display_link_to_published?
    !season_toggles.team_submissions_editable? && student.is_on_team? && team.submission.complete?
  end
end
