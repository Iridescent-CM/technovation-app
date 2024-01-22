class ChapterAmbassadorProfile < ActiveRecord::Base
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

  after_update :after_status_changed, if: :saved_change_to_status?

  enum status: %i[pending approved declined spam]

  validates :organization_company_name,
    :job_title,
    :bio,
    presence: true

  has_many :saved_searches, as: :searcher

  has_many :exports, as: :owner, dependent: :destroy
  has_many :regional_pitch_events

  has_many :messages, as: :sender
  has_many :multi_messages, as: :sender

  has_many :regional_links, dependent: :destroy

  accepts_nested_attributes_for :regional_links, reject_if: ->(attrs) {
    attrs.reject { |k, _| k.to_s == "custom_label" }.values.any?(&:blank?)
  }, allow_destroy: true

  delegate :submitted?,
    :candidate_id,
    :report_id,
    to: :background_check,
    prefix: true,
    allow_nil: true

  def method_missing(method_name, *args)
    account.public_send(method_name, *args)
  rescue
    raise NoMethodError,
      "undefined method `#{method_name}' not found for #{self}"
  end

  def self.staff_test_account_ids
    [
      20980
    ]
  end

  def provided_intro?
    !intro_summary.blank?
  end

  def needs_intro_prompt?
    !self.class.staff_test_account_ids.include?(account_id) and
      intro_summary.blank?
  end

  def background_check_complete?
    country_code != "US" or !!background_check && background_check.clear?
  end

  def requires_background_check?
    country_code == "US" and
      !background_check_complete?
  end

  def in_background_check_country?
    country_code == "US"
  end

  def in_background_check_invitation_country?
    false
  end

  def profile_complete?
    bio_complete?
  end

  def bio_complete?
    !bio.blank?
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

  def onboarded?
    account.email_confirmed? and
      approved? and
      background_check_complete?
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

  private

  def after_status_changed
    if approved?
      SubscribeAccountToEmailListJob.perform_later(
        account_id: account.id,
        profile_type: "chapter ambassador"
      )
    else
      DeleteAccountFromEmailListJob.perform_later(email_address: account.email)
    end
  end
end
