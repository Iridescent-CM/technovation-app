class ConsentWaiver < ActiveRecord::Base
  belongs_to :account

  validates :electronic_signature, presence: true

  delegate :full_name, :type_name, :consent_token, to: :account, prefix: true

  after_commit :enable_searchable_users, on: :create

  def account_consent_token=(token)
    self.account = Account.find_by(consent_token: token)
  end

  def signed_at
    created_at
  end

  def status
    "signed"
  end

  private
  def enable_searchable_users
    account.enable_searchability
  end
end
