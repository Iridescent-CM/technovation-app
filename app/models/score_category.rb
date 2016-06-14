class ScoreCategory < ActiveRecord::Base
  has_many :score_questions, dependent: :destroy

  accepts_nested_attributes_for :score_questions

  validates :name, presence: true, uniqueness: true

  scope :by_expertise, ->(judge) {
    joins('LEFT JOIN judge_expertises on judge_expertises.expertise_id = score_categories.id')
    .where('judge_expertises.user_role_id IN (?)', judge.user_role_ids)
  }
end
