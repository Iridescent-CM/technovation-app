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
              when :app_details
                :complete if submission.app_details.present?
              when :learning_journey
                :complete if submission.learning_journey.present?
              when :pitch_video
                :complete unless submission.pitch_video_link.blank?
              when :demo_video
                :complete unless submission.demo_video_link.blank?
              when :screenshots
                :complete if submission.screenshots.many?
              when :development_platform
                :complete if submission.submission_type.present? && submission.valid?
              when :source_code, :source_code_url
                if RequiredField.for(submission, :source_code_url).complete? and submission.valid?
                  :complete
                end
              when :business_plan
                if submission.junior_division? || submission.senior_division?
                  :complete if submission.business_plan_url.present?
                else
                  :not_required
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
