class JudgeAssignment < ActiveRecord::Base
  belongs_to :team
  belongs_to :assigned_judge, polymorphic: true

    # deprecated, use polymorphic
  belongs_to :judge_profile, required: false
    # deprecated


  delegate :name,
    to: :team,
    prefix: true,
    allow_nil: false

  delegate :email, :full_name,
    to: :assigned_judge,
    prefix: true,
    allow_nil: false
end
