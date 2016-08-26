class RegionalAmbassadorProfile < ActiveRecord::Base
  include Authenticatable

  belongs_to :regional_ambassador_account, foreign_key: :account_id

  after_update :notify_ambassador, if: :status_changed?

  enum status: %i{pending approved declined}

  validates :organization_company_name, :ambassador_since_year, :bio, presence: true

  def background_check_complete?
    not regional_ambassador_account.country == "US" or !!background_check_completed_at
  end

  def complete_background_check!
    unless background_check_completed_at?
      update_attributes(background_check_completed_at: Time.current)
    end
  end

  private
  def notify_ambassador
    AmbassadorMailer.public_send(status, account).deliver_later
  end
end
