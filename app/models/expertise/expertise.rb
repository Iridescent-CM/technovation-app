class Expertise < ActiveRecord::Base
  has_many :mentor_profile_expertises, class_name: "::MentorProfileExpertise"
  has_many :mentor_profiles, through: :mentor_profile_expertises

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
