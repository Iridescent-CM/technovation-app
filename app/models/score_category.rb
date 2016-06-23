class ScoreCategory < ActiveRecord::Base
  has_many :score_questions, dependent: :destroy

  accepts_nested_attributes_for :score_questions, allow_destroy: true

  validates :name, presence: true, uniqueness: true

  scope :is_expertise, -> { where(is_expertise: true) }

  scope :visible_to, ->(profile) {
    if profile.admin?
      all
    else
      joins('LEFT JOIN judge_scoring_expertises on judge_scoring_expertises.scoring_expertise_id = score_categories.id')
      .where('score_categories.is_expertise = false OR judge_scoring_expertises.judge_profile_id IN (?)', profile.id)
    end
  }
end
