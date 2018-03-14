class NullTeam < NullObject
  def touch
    # noop
  end

  def has_mentor?
    false
  end

  def current?
    false
  end

  def past?
    false
  end

  def mentors
    ::MentorProfile.none
  end

  def selected_regional_pitch_event
    ::NullEvent.new
  end

  def submission
    ::NullTeamSubmission.new
  end

  def pending_requests
    ::JoinRequest.none
  end

  def pending_student_join_requests
    ::JoinRequest.none
  end

  def pending_mentor_join_requests
    ::JoinRequest.none
  end
end
