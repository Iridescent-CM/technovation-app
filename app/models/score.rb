class Score < ActiveRecord::Base
  default_scope { includes(:score_values) }

  has_and_belongs_to_many :score_values

  def total
    score_values.inject(0) { |acc, value| value.value + acc }
  end
end
