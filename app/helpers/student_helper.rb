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
    status =  case piece.to_sym
              when :honor_code
                :complete if submission.present?
              when :team_photo
                :complete if submission.team_photo_uploaded?
              when :app_name
                if RequiredField.for(submission, :app_name).complete?
                  :complete
                end
              when :app_description
                :complete unless submission.app_description.blank?
              when :pitch_video
                :complete unless submission.pitch_video_link.blank?
              when :demo_video
                :complete unless submission.demo_video_link.blank?
              when :screenshots
                :complete if submission.screenshots.many?
              when :development_platform
                :complete unless submission.development_platform_text.blank?
              when :source_code, :source_code_url
                if RequiredField.for(submission, :source_code_url).complete?
                  :complete
                end
              when :business_plan
                if submission.junior_division?
                  :not_required
                else
                  :complete unless submission.business_plan_url.blank?
                end
              when :pitch_presentation
                if !submission.pitch_presentation_url.blank?
                  :complete
                elsif !submission.team.selected_regional_pitch_event.live?
                  :not_required
                end
              end

    if status == :complete
      web_icon("check-circle", { class: "icon--green", text: text })
    elsif status == :not_required
      web_icon("circle-o", { class: "not-required", text: text })
    else
      web_icon("circle-o", { class: "icon--orange", text: text })
    end
  end
end
