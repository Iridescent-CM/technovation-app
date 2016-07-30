class ScoreValue < ActiveRecord::Base
  belongs_to :score_question

  validates :label, presence: true, uniqueness: { case_sensitive: false,
                                                  scope: :score_question_id }

  scope :total, -> { sum(:value) }
end
