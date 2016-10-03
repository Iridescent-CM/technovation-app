class RegionalAmbassadorProfile < ActiveRecord::Base
  include Authenticatable

  belongs_to :regional_ambassador_account, foreign_key: :account_id

  after_update :after_status_changed, if: :status_changed?

  enum status: %i{pending approved declined spam}

  validates :organization_company_name, :ambassador_since_year, :job_title, :bio, presence: true

  private
  def after_status_changed
    AmbassadorMailer.public_send(status, account).deliver_later

    if approved?
      SubscribeEmailListJob.perform_later(regional_ambassador_account.email,
                                          regional_ambassador_account.full_name,
                                          ENV.fetch("REGIONAL_AMBASSADOR_LIST_ID"))
    end
  end
end
