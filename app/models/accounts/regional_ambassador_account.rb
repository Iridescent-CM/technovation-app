class RegionalAmbassadorAccount < Account
  default_scope { eager_load(:regional_ambassador_profile) }

  scope :pending, -> { where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[:pending]) }
  scope :approved, -> { where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[:approved]) }
  scope :declined, -> { where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[:declined]) }

  has_many :exports, foreign_key: :account_id, dependent: :destroy

  has_one :regional_ambassador_profile, foreign_key: :account_id
  accepts_nested_attributes_for :regional_ambassador_profile
  validates_associated :regional_ambassador_profile

  delegate :status,
           :approved!,
           :declined!,
           :approved?,
           :declined?,
           :pending!,
           :pending?,
           :spam!,
           :organization_company_name,
           :job_title,
           :ambassador_since_year,
           :background_check_complete?,
           :bio,
           :background_check_candidate_id,
           :background_check_report_id,
           :complete_background_check!,
           :background_check_submitted?,
    to: :regional_ambassador_profile,
    prefix: false

  delegate :id, to: :regional_ambassador_profile, prefix: true

  def profile_complete?
    bio_complete?
  end

  def bio_complete?
    not bio.blank?
  end
end
