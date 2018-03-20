module TeamSubmissionSectionController
  extend ActiveSupport::Concern

  included do
    layout "submissions"
  end

  def show
    @team_submission = current_team.submission
    @team = current_team

    @uploader = ImageUploader.new
    @uploader.success_action_redirect = send(
      "#{current_scope}_team_photo_upload_confirmation_url",
      team_id: @team.id,
      back: request.fullpath
    )

    set_cookie(
      :last_visited_submission_section,
      section_name,
    )

    render "team_submissions/sections/#{section_name}"
  end

  private
  def section_name
    name = params.fetch(:section) { "ideation" }

    if name.to_s.downcase === 'marketing'
      name = 'pitch'
    end

    name
  end
end
