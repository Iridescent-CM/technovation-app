class RegionalAmbassadorProfile < ActiveRecord::Base
  scope :full_access, -> { approved }

  belongs_to :account
  accepts_nested_attributes_for :account
  validates_associated :account

  after_update :after_status_changed, if: :status_changed?

  enum status: %i{pending approved declined spam}

  validates :organization_company_name, :ambassador_since_year, :job_title, :bio,
    presence: true

  has_many :exports, foreign_key: :account_id, dependent: :destroy

  delegate :submitted?,
           :candidate_id,
           :report_id,
    to: :background_check,
    prefix: true,
    allow_nil: true

  def method_missing(method_name, *args)
    begin
      account.public_send(method_name, *args)
    rescue
      raise NoMethodError, "undefined method `#{method_name}' not found for #{self}"
    end
  end

  def background_check_complete?
    country != "US" or !!background_check && background_check.clear?
  end

  def profile_complete?
    bio_complete?
  end

  def bio_complete?
    not bio.blank?
  end

  def region_name
    if country == "US"
      Country[country].states[state_province]['name']
    else
      Country[country].name
    end
  end

  def full_access_enabled?
    approved? and consent_signed? and background_check_complete?
  end

  def authenticated?
    true
  end

  def admin?
    false
  end

  def type_name
    "regional_ambassador"
  end

  private
  def after_status_changed
    AmbassadorMailer.public_send(status, account).deliver_later

    if approved?
      SubscribeEmailListJob.perform_later(
        account.email, account.full_name, "REGIONAL_AMBASSADOR_LIST_ID"
      )
    end
  end
end
