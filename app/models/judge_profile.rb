class JudgeProfile < ActiveRecord::Base
  scope :full_access, -> { joins(account: :consent_waiver) }

  belongs_to :account
  accepts_nested_attributes_for :account
  validates_associated :account

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

  def admin?
    false
  end

  def full_access_enabled?
    consent_signed?
  end

  def type_name
    "judge"
  end
end
