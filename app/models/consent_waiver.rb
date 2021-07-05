class ConsentWaiver < ActiveRecord::Base
  scope :nonvoid, -> { where("consent_waivers.voided_at IS NULL") }
  scope :void, -> { where("consent_waivers.voided_at IS NOT NULL") }

  belongs_to :account

  validates :electronic_signature, presence: true

  delegate :full_name,
           :scope_name,
           :consent_token,
    to: :account,
    prefix: true

  after_commit -> {
    if account.mentor_profile.present?
      account.mentor_profile.enable_searchability_with_save
    end

    if account.judge_profile.present?
      account.judge_profile.touch
    end
  }, on: :create

  def account_consent_token=(token)
    self.account = Account.find_by(consent_token: token)
  end

  def signed_at
    created_at
  end

  def status
    voided? ? "void" : "signed"
  end

  def signed?
    not voided?
  end

  def void!
    update(voided_at: Time.current)
  end

  def voided?
    !!voided_at
  end
  alias void? voided?
end
