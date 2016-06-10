class Score
  include ActiveModel::Model

  def self.all
    Feedback.all
  end

  def categories
    ScoreCategory.all
  end

  def score_value_id
  end

  def score_value_id=(score_value_id)
    Feedback.create(score_value_id: score_value_id)
  end

  def save
    true
  end
end
