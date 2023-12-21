module TeamSubmissionSectionController
  extend ActiveSupport::Concern

  included do
    layout "submissions"
  end

  def show
    unless SeasonToggles.team_submissions_editable? or section_name == "pitch_presentation"
      redirect_to send("#{current_scope}_dashboard_path") and return
    end

    @team_submission = current_team.submission
    @team = current_team

    @uploader = ImageDirectUploader.new
    @uploader.success_action_redirect = send(
      "#{current_scope}_team_photo_upload_confirmation_url",
      team_id: @team.id,
      back: request.fullpath
    )

    set_cookie(
      CookieNames::LAST_VISITED_SUBMISSION_SECTION,
      section_name
    )

    render "team_submissions/sections/#{section_name}"
  end

  private

  def section_name
    name = params.fetch(:section) { "ideation" }

    if name.to_s.downcase === "marketing"
      name = "pitch"
    end

    name
  end
end
