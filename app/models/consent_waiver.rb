class ConsentWaiver < ActiveRecord::Base
  scope :nonvoid, -> { where("voided_at IS NULL") }
  scope :void, -> { where("voided_at IS NOT NULL") }

  belongs_to :account

  validates :electronic_signature, presence: true

  delegate :full_name, :type_name, :consent_token, to: :account, prefix: true

  after_commit -> {
    if account.mentor_profile.present?
      account.mentor_profile.enable_searchability
    end

    if account.judge_profile
      SubscribeProfileToEmailList.perform_later(account.id, "JUDGE_LIST_ID")
    end
  }, on: :create

  def account_consent_token=(token)
    self.account = Account.find_by(consent_token: token)
  end

  def signed_at
    created_at
  end

  def status
    "signed"
  end
end
