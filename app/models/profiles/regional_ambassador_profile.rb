class RegionalAmbassadorProfile < ActiveRecord::Base
  include Authenticatable

  after_update :notify_ambassador, if: :status_changed?

  enum status: %i{pending approved declined}

  validates :organization_company_name, :ambassador_since_year, :bio, presence: true

  def background_check_complete?
    !!background_check_completed_at
  end

  private
  def notify_ambassador
    AmbassadorMailer.public_send(status, account).deliver_later
  end
end
