class AppsController < ApplicationController
  helper_method :current_scope,
    :determine_manifest

  layout "application_rebrand"

  def show
    @team_submission = TeamSubmission.friendly.find(params.fetch(:id))
    @team = @team_submission.team

    render "team_submissions/published"
  end

  private

  def current_scope
    "public"
  end

  def determine_manifest
    "public"
  end
end
