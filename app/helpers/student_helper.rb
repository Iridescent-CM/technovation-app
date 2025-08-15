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
    status = case piece.to_sym
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
      :complete if submission.learning_journey_complete?
    when :ethics_description
      :complete if submission.ethics_description.present?
    when :pitch_video
      :complete unless submission.pitch_video_link.blank?
    when :demo_video
      :complete unless submission.demo_video_link.blank?
    when :screenshots
      :complete if submission.screenshots.many?
    when :development_platform
      if submission.app_inventor_fields_complete? ||
          submission.thunkable_fields_complete? ||
          submission.scratch_fields_complete? ||
          submission.code_org_app_lab_fields_complete? ||
          submission.other_fields_complete?
        :complete
      end
    when :source_code, :source_code_url
      if submission.thunkable_source_code_fields_complete? ||
          submission.scratch_source_code_fields_complete? ||
          submission.code_org_app_lab_source_code_fields_complete? ||
          submission.source_code_url_complete?
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
      web_icon("check-circle", {class: "icon--green", text: text})
    elsif status == :not_required
      web_icon("check-circle", {class: "not-required", text: text})
    else
      web_icon("circle-o", {class: "icon--orange", text: text})
    end
  end

  def link_to_download_or_open_project(submission)
    if submission.developed_on?("Thunkable")
      submission.thunkable_project_url
    elsif submission.developed_on?("Scratch")
      submission.source_code.present? ? submission.source_code_url : submission.scratch_project_url
    elsif submission.developed_on?("Code.org App Lab")
      submission.code_org_app_lab_project_url
    elsif submission.developed_on?("Other") || submission.developed_on?("App Inventor")
      submission.source_code_url
    end
  end
end
