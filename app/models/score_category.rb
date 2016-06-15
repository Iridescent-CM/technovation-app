class ScoreCategory < ActiveRecord::Base
  has_many :score_questions, dependent: :destroy

  accepts_nested_attributes_for :score_questions

  validates :name, presence: true, uniqueness: true

  scope :visible_to, ->(authentication_role) {
    joins('LEFT JOIN judge_expertises on judge_expertises.expertise_id = score_categories.id')
    .where('judge_expertises.authentication_role_id IN (?)', authentication_role.id)
  }
end
