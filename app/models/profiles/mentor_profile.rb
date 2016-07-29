class MentorProfile < ActiveRecord::Base
  include Authenticatable

  has_many :mentor_profile_expertises, dependent: :destroy
  has_many :expertises, through: :mentor_profile_expertises

  validates :school_company_name, :job_title, presence: true

  def expertise_names
    expertises.flat_map(&:name)
  end

  def background_check_complete?
    !!background_check_completed_at
  end
end
