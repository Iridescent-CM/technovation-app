class Score < ActiveRecord::Base
  has_and_belongs_to_many :score_values

  def total
    score_values.inject(0) { |acc, value| value.value + acc }
  end
end
