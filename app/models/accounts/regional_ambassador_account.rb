class RegionalAmbassadorAccount < Account
  default_scope { joins(:regional_ambassador_profile) }

  scope :pending, -> { where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[:pending]) }
  scope :approved, -> { where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[:approved]) }
  scope :rejected, -> { where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[:rejected]) }

  after_initialize :build_regional_ambassador_profile,
    if: -> { regional_ambassador_profile.blank? }
  after_create :notify_admins

  has_one :regional_ambassador_profile, foreign_key: :account_id
  accepts_nested_attributes_for :regional_ambassador_profile
  validates_associated :regional_ambassador_profile

  delegate :organization_company_name,
           :ambassador_since_year,
    to: :regional_ambassador_profile,
    prefix: false

  private
  def notify_admins
    AdminMailer.pending_regional_ambassador(self).deliver_later
  end
end
