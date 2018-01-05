module TeamSubmissionController
  extend ActiveSupport::Concern

  def new
    unless SeasonToggles.team_submissions_editable?
      redirect_to [current_scope, :dashboard],
        alert: "Sorry, submissions are not editable at this time"
    end

    if current_team.submission.present?
      redirect_to [current_scope, current_team.submission]
    else
      @team_submission = current_team.team_submissions.build
      render "team_submissions/new"
    end
  end
end
