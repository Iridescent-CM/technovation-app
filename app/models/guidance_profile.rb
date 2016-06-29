class GuidanceProfile < ActiveRecord::Base
  include Authenticatable

  has_many :guidance_profile_expertises
  has_many :expertises, through: :guidance_profile_expertises

  validates :school_company_name, :job_title, presence: true
end
