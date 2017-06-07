class NullTeamSubmission
  def present?
    false
  end

  def screenshots
    Screenshot.none
  end

  def app_name
    "not started"
  end

  def quarterfinals_average_score
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

  def submission_scores
    SubmissionScore.none
  end

  def technical_checklist
    NullTechnicalChecklist.new
  end
end
