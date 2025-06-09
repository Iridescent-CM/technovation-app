class ClubAmbassadorProfile < ActiveRecord::Base
  include BackgroundCheckHelpers
  include OnboardingTasksConcern

  belongs_to :account
  accepts_nested_attributes_for :account
  validates_associated :account

  belongs_to :current_account, -> { current },
    class_name: "Account",
    foreign_key: "account_id",
    required: false

  has_many :exports, as: :owner, dependent: :destroy
  has_many :saved_searches, as: :searcher
  has_many :chapterable_assignments, as: :profile, class_name: "ChapterableAccountAssignment"

  validates :job_title, presence: true

  after_update :update_onboarding_status

  def method_missing(method_name, *args) # standard:disable all
    account.public_send(method_name, *args) # standard:disable all
  rescue
    raise NoMethodError,
      "undefined method `#{method_name}' not found for #{self}"
  end

  def full_name
    account.full_name
  end

  def email_address
    account.email
  end

  def rebranded?
    true
  end

  def national_view?
    false
  end

  def authenticated?
    true
  end

  def update_onboarding_status
    update_column(:onboarded, can_be_marked_onboarded?)
  end

  def can_be_marked_onboarded?
    !!(account.email_confirmed? &&
      background_check_exempt_or_complete? &&
      training_completed? &&
      viewed_community_connections?)
  end

  def required_onboarding_tasks
    {
      "Background Check" => background_check_exempt_or_complete?,
      "Club Ambassador Training" => training_completed?,
      "Community Connections" => viewed_community_connections?
    }
  end

  def in_background_check_country?
    ENV.fetch("BACKGROUND_CHECK_COUNTRY_CODES", "")
      .split(",")
      .include?(account.country_code)
  end

  def chapter_volunteer_agreement_complete?
    false
  end

  def training_completed?
    training_completed_at.present?
  end

  def complete_training!
    update(training_completed_at: Time.current)
  end

  def onboarding?
    !onboarded?
  end

  def chapterable
    account.current_primary_club
  end
  alias_method :club, :chapterable

  def chapterable_type
    "club"
  end

  def scope_name
    "club_ambassador"
  end

  def secondary_regions
    []
  end

  def other_regions
    secondary_regions
  end
end
