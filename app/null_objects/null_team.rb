class NullTeam < NullObject
  def id
    0
  end

  def touch
    # noop
  end

  def name
    '::NullTeam'
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

  def mentor_ids
    []
  end

  def selected_regional_pitch_event
    ::NullEvent.new
  end

  def live_event?
    false
  end

  def attending_event?(*)
    false
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

  def city
    false
  end

  def state_province
    false
  end

  def latitude
    false
  end

  def longitude
    false
  end

  def country
    ''
  end
end
