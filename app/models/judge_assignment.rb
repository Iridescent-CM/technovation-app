class JudgeAssignment < ActiveRecord::Base
  belongs_to :team
  belongs_to :judge_profile, required: false
  belongs_to :user_invitation, required: false

  delegate :name,
    to: :team,
    prefix: true,
    allow_nil: false

  delegate :full_name,
    to: :judge_profile,
    prefix: true,
    allow_nil: false

  delegate :email,
    to: :user_invitation,
    prefix: true,
    allow_nil: false
end
