class Expertise < ActiveRecord::Base
  has_many :guidance_profile_expertises, class_name: "::GuidanceProfileExpertise"
  has_many :guidance_profiles, through: :guidance_profile_expertises

  validates :name, presence: true, uniqueness: true
end
