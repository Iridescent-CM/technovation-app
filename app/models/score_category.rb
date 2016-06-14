class ScoreCategory < ActiveRecord::Base
  has_many :score_attributes, dependent: :destroy
  has_many :user_expertises

  accepts_nested_attributes_for :score_attributes

  validates :name, presence: true, uniqueness: true

  scope :by_expertise, ->(judge) {
    all.select { |sc| JudgingEnabledUserRole.find_by(user_id: judge.id).expertises.include?(sc) }
  }
end
