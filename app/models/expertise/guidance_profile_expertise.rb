class GuidanceProfileExpertise < ActiveRecord::Base
  belongs_to :guidance_profile
  belongs_to :expertise
end
