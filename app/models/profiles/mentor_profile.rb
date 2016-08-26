class MentorProfile < ActiveRecord::Base
  include Authenticatable

  belongs_to :mentor_account, foreign_key: :account_id

  has_many :mentor_profile_expertises, dependent: :destroy
  has_many :expertises, through: :mentor_profile_expertises

  after_validation -> { self.searchable = can_enable_searchable? },
    on: :update,
    if: :background_check_completed_at_changed?

  validates :school_company_name, :job_title, presence: true

  def expertise_names
    expertises.flat_map(&:name)
  end

  def background_check_complete?
    not mentor_account.country == "US" or !!background_check_completed_at
  end

  def enable_searchability
    update_attributes(searchable: can_enable_searchable?)
  end

  def complete_background_check!
    unless background_check_complete?
      update_attributes(background_check_completed_at: Time.current)
    end
  end

  private
  def can_enable_searchable?
    mentor_account.consent_waiver.present? && background_check_complete?
  end
end
