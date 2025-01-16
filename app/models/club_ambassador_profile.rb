class ClubAmbassadorProfile < ActiveRecord::Base
  belongs_to :account
  accepts_nested_attributes_for :account
  validates_associated :account

  belongs_to :current_account, -> { current },
    class_name: "Account",
    foreign_key: "account_id",
    required: false

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

  def authenticated?
    true
  end

  def update_onboarding_status
    update_column(:onboarded, can_be_marked_onboarded?)
  end

  def can_be_marked_onboarded?
    !!account.email_confirmed?
  end

  def training_completed?
    training_completed_at.present?
  end

  def onboarding?
    !onboarded?
  end

  def club
    account.current_primary_club
  end

  def scope_name
    "club_ambassador"
  end
end
