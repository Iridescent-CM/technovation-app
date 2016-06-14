class ScoreValue < ActiveRecord::Base
  belongs_to :score_question

  validates :label, presence: true, uniqueness: { scope: :score_question_id }

  scope :total, -> { sum(:value) }
end
