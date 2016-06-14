class Submission < ActiveRecord::Base
  belongs_to :team
  has_many :scores

  scope :visible_to, ->(judge) {
    joins('LEFT JOIN scores on scores.submission_id = submissions.id')
    .where('scores.judge_id NOT IN (?) OR scores.submission_id IS NULL',
           GetJudgeRole.(judge).id)
  }

  delegate :name, to: :team, prefix: true

  def self.random
    order('random()').limit(1).first
  end
end
