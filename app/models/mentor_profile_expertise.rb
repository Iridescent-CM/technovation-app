class MentorProfileExpertise < ActiveRecord::Base
  belongs_to :mentor_profile, required: false
  belongs_to :expertise

  validates_associated :mentor_profile
end
