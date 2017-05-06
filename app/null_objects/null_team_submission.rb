class NullTeamSubmission
  def present?
    false
  end

  def screenshots
    []
  end

  def app_name
    "not started"
  end

  def average_score
    0
  end

  def technical_checklist_started?
    false
  end

  def status
    'incomplete'
  end

  def complete?
    false
  end

  def technical_checklist
    NullTechnicalChecklist.new
  end
end
