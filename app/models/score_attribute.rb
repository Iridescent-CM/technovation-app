class ScoreAttribute < ActiveRecord::Base
  belongs_to :score_category
  has_many :score_values, dependent: :destroy

  accepts_nested_attributes_for :score_values

  validates :label, presence: true, uniqueness: { scope: :score_category_id }
end
