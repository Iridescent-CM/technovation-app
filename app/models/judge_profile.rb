class JudgeProfile < ActiveRecord::Base
  scope :full_access, -> {
    joins(account: :consent_waiver)
      .where("accounts.location_confirmed = ?", true)
  }

  belongs_to :account
  accepts_nested_attributes_for :account
  validates_associated :account

  has_many :submission_scores

  validates :company_name, :job_title,
    presence: true

  def method_missing(method_name, *args)
    begin
      account.public_send(method_name, *args)
    rescue
      raise NoMethodError, "undefined method `#{method_name}' not found for #{self}"
    end
  end

  def authenticated?
    true
  end

  def full_access_enabled?
    consent_signed? and location_confirmed?
  end

  def type_name
    "judge"
  end
end
