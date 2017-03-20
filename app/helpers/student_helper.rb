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

  def subprog(submission, step)
    case step
    when "team-photo"
      return 'complete' if submission.team.team_photo.present?

    when "app-info"
      unless submission.app_name.blank? or submission.app_description.blank?
        return 'complete'
      end

    when "sdg"
      unless submission.stated_goal.blank? or submission.stated_goal_explanation.blank?
        return 'complete'
      end

    when "pitch"
      return 'complete' unless submission.pitch_video_link.blank?

    when "demo"
      return 'complete' unless submission.demo_video_link.blank?

    when "screenshots"
      return 'complete' if submission.screenshots.count >= 2

    when "technical-checklist"
      return 'complete' if submission.technical_checklist_completed?

    when "source-code"
      return 'complete' unless submission.detect_source_code_url.blank?

    when "development-platform"
      return 'complete' unless submission.development_platform_text.blank?

    when "business-plan"
      return 'complete' unless submission.business_plan_url_text.blank?

    when "pitch-presentation"
      return 'complete' if submission.pitch_presentation_complete?

    end
  end
end
