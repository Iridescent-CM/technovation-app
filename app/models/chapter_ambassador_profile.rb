class ChapterAmbassadorProfile < ActiveRecord::Base
  include BackgroundCheckHelpers
  include OnboardingTasksConcern

  scope :onboarded, -> {
    approved.joins(:account)
      .where("accounts.email_confirmed_at IS NOT NULL")
  }

  scope :not_staff, -> {
    joins(:account)
      .where.not("accounts.email ILIKE ?", "%joesak%")
  }

  belongs_to :account
  accepts_nested_attributes_for :account
  validates_associated :account

  belongs_to :current_account, -> { current },
    class_name: "Account",
    foreign_key: "account_id",
    required: false

  enum status: %i[pending approved declined spam]
  enum organization_status: {
    employee: "employee",
    volunteer: "volunteer"
  }

  validates :job_title, presence: true

  has_one :chapter_volunteer_agreement, -> { where(active: true) }, class_name: "Document", as: :signer
  has_many :documents, as: :signer

  has_many :saved_searches, as: :searcher

  has_many :exports, as: :owner, dependent: :destroy
  has_many :regional_pitch_events

  has_many :messages, as: :sender
  has_many :multi_messages, as: :sender

  has_many :chapterable_assignments, as: :profile, class_name: "ChapterableAccountAssignment"
  has_many :chapter_links, dependent: :destroy

  has_one :community_connection

  accepts_nested_attributes_for :chapter_links, reject_if: ->(attrs) {
    attrs.reject { |k, _| k.to_s == "custom_label" }.values.any?(&:blank?)
  }, allow_destroy: true

  after_update :update_onboarding_status

  def method_missing(method_name, *args) # standard:disable all
    account.public_send(method_name, *args) # standard:disable all
  rescue
    raise NoMethodError,
      "undefined method `#{method_name}' not found for #{self}"
  end

  def self.staff_test_account_ids
    [
      20980
    ]
  end

  def full_name
    account.full_name
  end

  def email_address
    account.email
  end

  def provided_intro?
    !intro_summary.blank?
  end

  def profile_complete?
    bio_complete?
  end

  def bio_complete?
    !bio.blank?
  end

  def training_completed?
    training_completed_at.present?
  end

  def complete_training!
    update(training_completed_at: Time.current)
  end

  def community_connections_viewed?
    viewed_community_connections
  end

  def chapterable
    account.current_primary_chapter
  end
  alias_method :chapter, :chapterable

  def chapterable_type
    "chapter"
  end

  def chapter_volunteer_agreement_complete?
    reload

    !!chapter_volunteer_agreement&.complete?
  end

  def required_onboarding_tasks
    {
      "Background Check" => background_check_exempt_or_complete?,
      "Chapter Ambassador Training" => training_completed?,
      "Chapter Volunteer Agreement" => chapter_volunteer_agreement_complete?,
      "Community Connections" => viewed_community_connections?
    }
  end

  def region_name
    return unless Country[country]

    if country_code == "US"
      Country[country_code].states.fetch(state_province) { {} }["name"]
    else
      Country[country].name
    end
  end
  alias_method :primary_region, :region_name

  def other_regions
    secondary_regions
  end

  def rebranded?
    true
  end

  def can_be_marked_onboarded?
    !!(account.email_confirmed? &&
      background_check_exempt_or_complete? &&
      chapter_volunteer_agreement_complete? &&
      training_completed? &&
      viewed_community_connections?)
  end

  def onboarding?
    !onboarded?
  end

  def authenticated?
    true
  end

  def scope_name
    "chapter_ambassador"
  end

  def update_onboarding_status
    update_column(:onboarded, can_be_marked_onboarded?)
  end
end
