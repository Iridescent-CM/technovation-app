class JudgeProfile < ActiveRecord::Base
  scope :full_access, -> { joins(:consent_waiver) }

  belongs_to :account
  accepts_nested_attributes_for :account

  validates :company_name, :job_title,
    presence: true

  delegate :mentor_profile,
           :profile_image_url,
           :email,
    to: :account

  def authenticated?
    true
  end

  def admin?
    false
  end

  def full_access_enabled?
    consent_waiver.present?
  end
end
