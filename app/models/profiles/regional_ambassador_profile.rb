class RegionalAmbassadorProfile < ActiveRecord::Base
  include Authenticatable

  after_update :notify_ambassador, if: :just_approved?

  enum status: %i{pending approved rejected}

  validates :organization_company_name, :ambassador_since_year, presence: true

  def background_check_complete?
    !!background_check_completed_at
  end

  private
  def just_approved?
    status_changed? and approved?
  end

  def notify_ambassador
    AmbassadorMailer.approved(account).deliver_later
  end
end
