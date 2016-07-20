class RegionalAmbassadorAccount < Account
  default_scope { joins(:regional_ambassador_profile) }

  after_initialize :build_regional_ambassador_profile,
    if: -> { regional_ambassador_profile.blank? }

  has_one :regional_ambassador_profile, foreign_key: :account_id
  accepts_nested_attributes_for :regional_ambassador_profile
  validates_associated :regional_ambassador_profile

  delegate :organization_company_name,
           :ambassador_since_year,
    to: :regional_ambassador_profile,
    prefix: false
end
