module PublishedSubmissionConfirmationController
  extend ActiveSupport::Concern

  def show
    @team_submission = current_team.submission
    render "published_submissions/confirm"
  end
end
