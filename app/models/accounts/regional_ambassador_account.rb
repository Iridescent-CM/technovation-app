class RegionalAmbassadorAccount < Account
  default_scope { joins(:regional_ambassador_profile) }

  scope :pending, -> { where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[:pending]) }
  scope :approved, -> { where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[:approved]) }
  scope :rejected, -> { where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[:rejected]) }

  has_one :regional_ambassador_profile, foreign_key: :account_id
  accepts_nested_attributes_for :regional_ambassador_profile
  validates_associated :regional_ambassador_profile

  delegate :status,
           :approved!,
           :rejected!,
           :organization_company_name,
           :ambassador_since_year,
    to: :regional_ambassador_profile,
    prefix: false

  def background_check_complete?
    false
  end

  def profile_complete?
    false
  end
end
