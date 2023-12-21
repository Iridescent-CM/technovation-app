class JudgeAssignment < ActiveRecord::Base
  include Seasoned

  after_commit -> {
    if seasons.empty?
      update_column(:seasons, [Season.current.year])
    end
  }, on: :create

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
