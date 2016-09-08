class RegionalAmbassadorProfile < ActiveRecord::Base
  include Authenticatable

  belongs_to :regional_ambassador_account, foreign_key: :account_id

  after_update :after_status_changed, if: :status_changed?

  enum status: %i{pending approved declined}

  validates :organization_company_name, :ambassador_since_year, :job_title, :bio, presence: true

  def background_check_complete?
    not regional_ambassador_account.country == "US" or !!background_check_completed_at
  end

  def background_check_submitted?
    !!background_check_candidate_id and !!background_check_report_id
  end

  def complete_background_check!
    unless background_check_complete?
      update_attributes(background_check_completed_at: Time.current)
    end
  end

  private
  def after_status_changed
    unless pending?
      AmbassadorMailer.public_send(status, account).deliver_later
    end

    if approved?
      SubscribeEmailListJob.perform_later(regional_ambassador_account.email,
                                          regional_ambassador_account.full_name,
                                          ENV.fetch("REGIONAL_AMBASSADOR_LIST_ID"))
    end
  end
end
