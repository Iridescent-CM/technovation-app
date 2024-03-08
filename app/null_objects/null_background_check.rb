class NullBackgroundCheck < NullObject
  def id
    0
  end

  def invitation_id
    nil
  end

  def report_id
    nil
  end

  def updated_at
    0
  end

  def status
    "none"
  end

  def new_record?
    false
  end

  def clear?
    false
  end

  def pending?
    false
  end

  def consider?
    false
  end

  def suspended?
    false
  end

  def paranoid?
    false
  end

  def invitation_status
    nil
  end

  def invitation_pending?
    false
  end

  def invitation_completed?
    false
  end

  def invitation_expired?
    false
  end

  def invitation_sent?
    false
  end

  def requesting_invitation?
    false
  end

  def error?
    false
  end

  def candidate_id
    nil
  end
end
