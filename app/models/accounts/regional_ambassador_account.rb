class RegionalAmbassadorAccount < Account
  default_scope { joins(:regional_ambassador_profile) }

  scope :pending, -> { where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[:pending]) }
  scope :approved, -> { where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[:approved]) }
  scope :declined, -> { where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[:declined]) }

  has_one :regional_ambassador_profile, foreign_key: :account_id
  accepts_nested_attributes_for :regional_ambassador_profile
  validates_associated :regional_ambassador_profile

  delegate :status,
           :approved!,
           :declined!,
           :organization_company_name,
           :job_title,
           :ambassador_since_year,
           :background_check_complete?,
           :bio,
    to: :regional_ambassador_profile,
    prefix: false

  delegate :id, to: :regional_ambassador_profile, prefix: true

  def profile_complete?
    profile_image? and bio_complete?
  end

  def bio_complete?
    not bio.blank?
  end
end
