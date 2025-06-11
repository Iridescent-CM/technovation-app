class Club < ActiveRecord::Base
  include Seasoned
  include ActiveGeocoded
  include SeasonStatusHelpers
  include Casting::Client
  delegate_missing_methods

  belongs_to :primary_contact, class_name: "Account", foreign_key: "primary_account_id", optional: true

  has_many :chapterable_account_assignments, as: :chapterable, class_name: "ChapterableAccountAssignment"
  has_many :accounts, through: :chapterable_account_assignments
  has_many :club_ambassadors, -> { where "profile_type = 'ClubAmbassadorProfile'" },
    through: :chapterable_account_assignments,
    source: :account

  validates :name, presence: true
  validates :summary, length: {maximum: 1000}

  after_update :update_onboarding_status

  def assign_address_details(geocoded)
    self.city = geocoded.city
    self.state_province = geocoded.state_code
    self.country = geocoded.country_code
  end

  def update_onboarding_status
    update_column(:onboarded, can_be_marked_onboarded?)
  end

  def can_be_marked_onboarded?
    !!(location_complete? &&
      club_info_complete?)
  end

  def location_complete?
    headquarters_location.present?
  end

  def club_info_complete?
    [
      name,
      summary,
      primary_contact
    ].all?(&:present?)
  end

  def secondary_regions
    []
  end
end
