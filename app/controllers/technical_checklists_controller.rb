class TechnicalChecklistsController < ApplicationController
  helper_method :current_team

  def show
    @team_submission = TeamSubmission.find(params[:id])
    @technical_checklist = @team_submission.technical_checklist
  end

  private
  def current_team
    @team_submission ||= TeamSubmission.find(params[:id])
    @team ||= @team_submission.team
  end
end
