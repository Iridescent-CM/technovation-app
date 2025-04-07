require "./app/null_objects/null_object"

class NullTeamSubmission < NullObject
  def qualifies_for_participation?
    false
  end

  def semifinalist?
    false
  end

  def regional_honoree?
    false
  end

  def special_prize_winner?
    false
  end

  def finalist?
    false
  end

  def grand_prize_winner?
    false
  end

  def screenshots
    ::Screenshot.none
  end

  def pitch_video_link
    ""
  end

  def app_name
    TeamSubmission::DEFAULT_APP_NAME
  end
  alias_method :name, :app_name

  def quarterfinals_average_score
    0
  end

  def status
    "incomplete"
  end

  def complete?
    false
  end
  alias_method :is_complete, :complete?

  def incomplete?
    true
  end

  def published_at
    nil
  end

  def missing_pieces
    []
  end

  def submission_scores
    ::SubmissionScore.none
  end

  def scores
    ::SubmissionScore.none
  end

  def touch
    false
  end

  def percent_complete
    0
  end
end
