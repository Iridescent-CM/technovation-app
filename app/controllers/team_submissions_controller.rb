class TeamSubmissionsController < ApplicationController
  helper_method :current_team

  def show
    @team_submission = TeamSubmission.find(params[:id])
  end

  private
  def current_team
    @team_submission ||= TeamSubmission.find(params[:id])
    @team ||= @team_submission.team
  end
end
