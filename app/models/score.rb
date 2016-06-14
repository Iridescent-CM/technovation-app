class Score < ActiveRecord::Base
  default_scope { includes(:score_values) }

  belongs_to :judge, class_name: "UserRole"

  belongs_to :submission
  has_one :team, through: :submission

  has_many :scored_values, dependent: :destroy
  has_many :score_values, through: :scored_values

  scope :visible_to, ->(user) {
    joins(:judge).where(judge_id: user.user_role_ids)
  }

  delegate :name, to: :team, prefix: true

  def total
    score_values.total
  end

  def score_value_selected?(score_value)
    score_value_ids.include?(score_value.id)
  end
end
