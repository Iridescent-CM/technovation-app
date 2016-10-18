class RegionalAmbassadorAccount < Account
  default_scope { eager_load(:regional_ambassador_profile) }

  scope :full_access, -> { approved }

  scope :pending, -> { where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[:pending]) }
  scope :approved, -> { where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[:approved]) }
  scope :declined, -> { where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[:declined]) }

  has_many :exports, foreign_key: :account_id, dependent: :destroy

  has_one :regional_ambassador_profile, foreign_key: :account_id
  accepts_nested_attributes_for :regional_ambassador_profile
  validates_associated :regional_ambassador_profile

  has_one :background_check, foreign_key: :account_id, dependent: :destroy
  accepts_nested_attributes_for :background_check

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
           :bio,
    to: :regional_ambassador_profile,
    prefix: false

  delegate :id, to: :regional_ambassador_profile, prefix: true

  delegate :submitted?,
           :candidate_id,
           :report_id,
    to: :background_check,
    prefix: true,
    allow_nil: true

  def background_check_complete?
    country != "US" or !!background_check && background_check.clear?
  end

  def profile_complete?
    bio_complete?
  end

  def bio_complete?
    not bio.blank?
  end

  def after_background_check_clear
    AccountMailer.background_check_clear(self).deliver_later
  end

  def region_name
    if country == "US"
      Country[country].states[state_province]['name']
    else
      Country[country].name
    end
  end
end
