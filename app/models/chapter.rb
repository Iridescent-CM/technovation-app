class Chapter < ActiveRecord::Base
  include Seasoned
  include ActiveGeocoded
  include OnboardingTasksConcern
  include SeasonStatusHelpers

  include Casting::Client
  delegate_missing_methods

  belongs_to :primary_contact, class_name: "Account", foreign_key: "primary_account_id", optional: true

  has_one :legal_contact, dependent: :destroy
  has_one :chapter_program_information, dependent: :destroy

  has_many :chapterable_account_assignments, as: :chapterable, class_name: "ChapterableAccountAssignment"
  has_many :accounts, through: :chapterable_account_assignments
  has_many :chapter_ambassadors, -> { where "profile_type = 'ChapterAmbassadorProfile'" },
    through: :chapterable_account_assignments,
    source: :account

  has_many :chapter_links, dependent: :destroy
  has_many :student_profiles
  has_many :registration_invites, class_name: "UserInvitation", dependent: :destroy

  accepts_nested_attributes_for :chapter_links, reject_if: ->(attrs) {
    attrs.reject { |k, _| k.to_s == "custom_label" }.values.any?(&:blank?)
  }, allow_destroy: true

  after_update :update_onboarding_status

  validates :summary, length: {maximum: 1000}

  scope :signed_affiliation_agreements, -> {
    joins(legal_contact: :documents)
      .where("documents.active = TRUE AND documents.status = 'signed' OR documents.status = 'off-platform'")
  }

  scope :not_signed_affiliation_agreements, -> {
    joins(legal_contact: :documents)
      .where("documents.active = TRUE AND documents.signed_at IS NULL")
  }

  scope :not_sent_affiliation_agreements, -> {
    left_joins(legal_contact: :documents)
      .where("documents.active != TRUE OR documents.active IS NULL")
      .where("documents.id IS NULL")
  }

  delegate :seasons_chapter_affiliation_agreement_is_valid_for, to: :legal_contact

  def affiliation_agreement
    legal_contact&.reload&.chapter_affiliation_agreement
  end

  def can_be_marked_onboarded?
    !!(affiliation_agreement_complete? &&
      chapter_info_complete? &&
      location_complete? &&
      program_info_complete?)
  end

  def assign_address_details(geocoded)
    self.city = geocoded.city
    self.state_province = geocoded.state_code
    self.country = geocoded.country_code
  end

  def update_onboarding_status
    update_column(:onboarded, can_be_marked_onboarded?)
  end

  def affiliation_agreement_complete?
    !!affiliation_agreement&.complete?
  end

  def chapter_info_complete?
    [
      name,
      summary,
      primary_contact,
      chapter_links
    ].all?(&:present?)
  end

  def location_complete?
    organization_headquarters_location.present?
  end

  def program_info_complete?
    chapter_program_information&.complete?
  end

  def required_onboarding_tasks
    {
      "Chapter Affiliation Agreement" => affiliation_agreement_complete?,
      "Public Info" => chapter_info_complete?,
      "Chapter Location" => location_complete?,
      "Program Info" => program_info_complete?
    }
  end

  def secondary_regions
    []
  end
end
