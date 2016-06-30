class ScoredValue < ActiveRecord::Base
  belongs_to :score
  belongs_to :score_value

  def self.comment(score_question)
    if !!(scored_value = where(score_value_id: score_question.score_value_ids).first)
      scored_value.comment
    else
      ""
    end
  end

  def self.id(score_question)
    if !!(scored_value = where(score_value_id: score_question.score_value_ids).first)
      scored_value.id
    else
      ""
    end
  end
end
