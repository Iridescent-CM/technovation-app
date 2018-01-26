module StudentHelper
  def mentor_invitation_template(team, mentor)
    if team.invited_mentor?(mentor)
      "already_invited"
    elsif mentor.requested_to_join?(team)
      "mentor_already_requested"
    elsif mentor.is_on?(team)
      "mentor_is_on_team"
    else
      "invite_mentor"
    end
  end

  def completion_css(submission, piece)
    submission.public_send("#{piece}_complete?") ?
      "complete" :
      "incomplete"
  end

  def submission_progress_web_icon(submission, piece, text)
    complete_icon = "check-circle"
    complete_opts = { class: "icon--green" }

    incomplete_icon = "circle-o"
    incomplete_opts = { class: "icon--orange" }

    not_required_opts = { class: "not-required" }

    status = :incomplete

    case piece.to_sym
    when :honor_code
      status = :complete if submission.present?
    when :team_photo
      status = :complete if submission.team_photo_uploaded?
    when :app_name
      if RequiredAppNameField.new(submission, :app_name).complete?
        status = :complete
      end
    when :app_description
      status = :complete unless submission.app_description.blank?
    when :pitch_video
      status = :complete unless submission.pitch_video_link.blank?
    when :demo_video
      status = :complete unless submission.demo_video_link.blank?
    when :screenshots
      status = :complete if submission.screenshots.many?
    when :development_platform
      status = :complete unless submission.development_platform_text.blank?
    when :source_code
      status = :complete unless submission.source_code_url.blank?
    when :code_checklist
      status = :complete if submission.code_checklist_complete?
    when :business_plan
      status = :complete unless submission.business_plan_url.blank?
      status = :not_required if submission.junior_division?
    when :pitch_presentation
      status = :complete unless submission.pitch_presentation_url.blank?

      unless submission.team.selected_regional_pitch_event.live?
        status = :not_required
      end
    end

    if status == :complete
      web_icon(complete_icon, complete_opts.merge(text: text))
    elsif status == :not_required
      web_icon(incomplete_icon, not_required_opts.merge(text: text))
    else
      web_icon(incomplete_icon, incomplete_opts.merge(text: text))
    end
  end
end
