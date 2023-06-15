class MentorType < ActiveRecord::Base
  has_many :mentor_profile_mentor_types
  has_many :mentor_profiles, through: :mentor_profile_mentor_types

  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
