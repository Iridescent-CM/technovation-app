class ParentalConsent < ActiveRecord::Base
  include Seasoned

  enum status: %i{
    pending
    signed
    voided
  }

  belongs_to :student_profile

  scope :nonvoid, -> { current }
  scope :void, -> { past }

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
  }, on: :update, if: :signed?

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
    SubscribeEmailListJob.perform_later(
      student_profile_email,
      student_profile_full_name,
      "STUDENT_LIST_ID"
    )

    AccountMailer.confirm_next_steps(self).deliver_later
  end

  def after_signed_parent_actions
    if newsletter_opt_in?
      SubscribeEmailListJob.perform_later(
        student_profile.parent_guardian_email,
        student_profile.parent_guardian_name,
        "PARENT_LIST_ID"
      )
    end

    ParentMailer.confirm_consent_finished(id).deliver_later

    if Rails.env.production?
      # TODO: entire test suite requires rewrite due to "wait: 3.days"
      ParentMailer.thank_you(id).deliver_later(wait: 3.days)
    end
  end
end
