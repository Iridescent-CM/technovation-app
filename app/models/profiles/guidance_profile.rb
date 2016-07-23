class GuidanceProfile < ActiveRecord::Base
  include Authenticatable

  has_many :guidance_profile_expertises, dependent: :destroy
  has_many :expertises, through: :guidance_profile_expertises

  validates :school_company_name, :job_title, presence: true

  def expertise_names
    expertises.flat_map(&:name)
  end
end
