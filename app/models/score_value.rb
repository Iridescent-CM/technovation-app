class ScoreValue < ActiveRecord::Base
  belongs_to :score_attribute

  validates :label, presence: true, uniqueness: { scope: :score_attribute_id }

  scope :total, -> { sum(:value) }
end
