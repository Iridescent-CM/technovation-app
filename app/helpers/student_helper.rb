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
    incomplete_opts = {}

    status = :incomplete

    case piece.to_sym
    when :honor_code
      status = :complete if submission.present?
    when :team_photo
      status = :complete if submission.team_photo_uploaded?
    when :app_name
      status = :complete unless submission.app_name.blank?
    when :app_description
      status = :complete unless submission.app_description.blank?
    when :pitch_video
      status = :complete unless submission.pitch_video_link.blank?
    when :demo_video
      status = :complete unless submission.demo_video_link.blank?
    when :screenshots
      status = :complete if submission.screenshots.many?
    when :development_patform
      status = :complete unless submission.development_platform_text.blank?
    when :source_code
      status = :complete unless submission.source_code_url.blank?
    when :code_checklist
      status = :complete if submission.code_checklist_complete?
    end

    if status == :complete
      web_icon(complete_icon, complete_opts.merge(text: text))
    else
      web_icon(incomplete_icon, incomplete_opts.merge(text: text))
    end
  end
end
