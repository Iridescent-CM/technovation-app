class MentorProfileExpertise < ActiveRecord::Base
  belongs_to :signup_attempt, required: false
  belongs_to :mentor_profile, required: false
  belongs_to :expertise

  validates_associated :mentor_profile, if: -> { signup_attempt.blank? }
end
