class Score < ActiveRecord::Base
  default_scope { includes(:score_values) }

  belongs_to :judge, class_name: "AuthenticationRole"

  belongs_to :submission
  has_one :team, through: :submission

  has_many :scored_values, dependent: :destroy
  has_many :score_values, through: :scored_values

  accepts_nested_attributes_for :scored_values, reject_if: :all_blank

  scope :visible_to, ->(authentication_role) {
    joins(:judge).where(judge_id: authentication_role.id)
  }

  delegate :name, to: :team, prefix: true

  def total
    score_values.total
  end

  def score_value_selected?(score_value)
    score_value_ids.include?(score_value.id)
  end
end
