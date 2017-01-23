class TeamSubmissionsController < ApplicationController
  helper_method :current_team

  layout 'public_team_submissions'

  def show
    @team_submission = TeamSubmission.friendly.find(params[:id])
  end

  private
  def current_team
    @team_submission ||= TeamSubmission.friendly.find(params[:id])
    @team ||= @team_submission.team
  end
end
