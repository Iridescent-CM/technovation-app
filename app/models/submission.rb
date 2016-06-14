class Submission < ActiveRecord::Base
  belongs_to :team
  has_many :scores

  scope :not_yet_judged_by, ->(judge) {
    joins('LEFT JOIN scores on scores.submission_id = submissions.id')
    .where('scores.judge_id NOT IN (?) OR scores.submission_id IS NULL', judge.id)
  }

  delegate :name, to: :team, prefix: true
end
