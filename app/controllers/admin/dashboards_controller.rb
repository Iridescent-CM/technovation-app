module Admin
  class DashboardsController < AdminController
    def show
      @students = StudentProfile.current

      @mentors = Account.current.left_outer_joins(:mentor_profile)
        .where("mentor_profiles.id IS NOT NULL")

      @permitted_students = @students.joins(:signed_parental_consent)
      @unpermitted_students = @students.joins(:pending_parental_consent)

      @new_students = @students.where(
        "accounts.created_at > ?",
        Date.new(Season.current.year - 1, 10, 18)
      )

      @returning_students = @students.where(
        "accounts.created_at < ?",
        Date.new(Season.current.year - 1, 10, 18)
      )

      @new_mentors = @mentors.where(
        "accounts.created_at > ?",
        Date.new(Season.current.year - 1, 10, 18)
      )

      @returning_mentors = @mentors.where(
        "accounts.created_at < ?",
        Date.new(Season.current.year - 1, 10, 18)
      )

      @cleared_mentors = @mentors.bg_check_clear.consent_signed

      @signed_consent_mentors = @mentors.bg_check_submitted.consent_signed

      @cleared_bg_check_mentors = @mentors.bg_check_clear.consent_not_signed

      @neither_mentors = @mentors.bg_check_unsubmitted.consent_not_signed
    end
  end
end
