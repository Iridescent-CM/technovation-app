class MentorProfileExpertise < ActiveRecord::Base
  belongs_to :mentor_profile
  belongs_to :expertise
end
