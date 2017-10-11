class NullTeam
  def touch
    # noop
  end

  def has_mentor?
    false
  end

  def present?
    false
  end

  def mentors
    MentorProfile.none
  end

  def selected_regional_pitch_event
    nil
  end

  def current_team_submission
    NullTeamSubmission.new
  end

  def submission
    NullTeamSubmission.new
  end

  def pending_requests
    JoinRequest.none
  end

  def pending_student_join_requests
    JoinRequest.none
  end

  def pending_mentor_join_requests
    JoinRequest.none
  end
end
