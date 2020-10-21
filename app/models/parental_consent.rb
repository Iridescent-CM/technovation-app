class ParentalConsent < ActiveRecord::Base
  include Seasoned

  # If these change, you will need to update dataclips
  enum status: %i{
    pending
    signed
    voided
  }

  belongs_to :student_profile

  scope :nonvoid, -> { current }
  scope :void, -> { past }
  scope :unsigned, -> { where(electronic_signature: nil) }

  validates :electronic_signature, presence: true, if: :signed?

  delegate :email,
           :first_name,
           :full_name,
           :consent_token,
           :locale,
    to: :student_profile,
    prefix: true

  before_validation -> {
    if Array(seasons).empty?
      self.seasons = [Season.current.year]
    end
  }, on: :create

  after_commit -> {
    after_signed_student_actions
    after_signed_parent_actions
  }, on: :update, if: ->(pc) {
    pc.saved_change_to_status and pc.signed?
  }

  after_commit -> {
    if saved_change_to_status
      student_profile.update(updated_at: Time.current)
    end
  }

  def student_profile_consent_token=(token)
    self.student_profile = StudentProfile.joins(:account)
      .find_by("accounts.consent_token = ?", token)
  end

  def signed_at
    created_at
  end

  def voided?
    seasons != [Season.current.year]
  end
  alias void? voided?

  def after_signed_student_actions
    AccountMailer.confirm_next_steps(self).deliver_later
  end

  def after_signed_parent_actions
    if newsletter_opt_in?
      SubscribeParentToEmailListJob.perform_later(student_profile_id: student_profile.id)
    end

    ParentMailer.confirm_consent_finished(id).deliver_later

    if Rails.env.production?
      # TODO: entire test suite requires rewrite due to "wait: 3.days"
      ParentMailer.thank_you(id).deliver_later(wait: 3.days)
    end
  end

  def name
    "parental consent for #{student_profile.name}"
  end
end
