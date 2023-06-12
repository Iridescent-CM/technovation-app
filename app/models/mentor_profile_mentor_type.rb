class MentorProfileMentorType < ActiveRecord::Base
  belongs_to :mentor_profile
  belongs_to :mentor_type
end
