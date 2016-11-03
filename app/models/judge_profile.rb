class JudgeProfile < ActiveRecord::Base
  belongs_to :account

  validates :company_name, :job_title,
    presence: true

  delegate :consent_waiver,
           :mentor_profile,
           :profile_image_url,
    to: :account

  def authenticated?
    true
  end

  def full_access_enabled?
    consent_waiver.present?
  end
end
