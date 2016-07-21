class RegionalAmbassadorProfile < ActiveRecord::Base
  include Authenticatable

  after_update :notify_ambassador, if: :just_approved?

  enum status: %i{pending approved rejected}

  validates :organization_company_name, :ambassador_since_year, presence: true

  private
  def just_approved?
    status_changed? and approved?
  end

  def notify_ambassador
    AmbassadorMailer.approved(account).deliver_later
  end
end
