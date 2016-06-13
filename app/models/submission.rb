class Submission < ActiveRecord::Base
  belongs_to :team
  has_many :scores

  scope :not_yet_judged_by, ->(judge) {
    includes(:scores).all.select { |s|
      !s.scores.flat_map(&:judge_id).include?(judge.id)
    }
  }

  delegate :name, to: :team, prefix: true
end
