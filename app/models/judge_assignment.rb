class JudgeAssignment < ActiveRecord::Base
  belongs_to :team
  belongs_to :judge_profile

  delegate :name,
    to: :team,
    prefix: true,
    allow_nil: false

  delegate :full_name,
    to: :judge_profile,
    prefix: true,
    allow_nil: false
end
