require "./app/null_objects/null_object"

class NullTeamSubmission < NullObject
  def qualifies_for_participation?
    false
  end

  def semifinalist?
    false
  end

  def screenshots
    ::Screenshot.none
  end

  def app_name
    "not started"
  end
  alias :name :app_name

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
    ::SubmissionScore.none
  end

  def scores
    ::SubmissionScore.none
  end

  def technical_checklist
    ::NullTechnicalChecklist.new
  end

  def touch
    false
  end

  def percent_complete
    0
  end
end
