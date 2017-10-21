module Admin
  class DashboardsController < AdminController
    def show
      @students = StudentProfile.current

      @mentors = MentorProfile.current

      @cleared_mentors = MentorProfile
        .left_outer_joins(current_account: [:consent_waiver, :background_check])
        .where(
          "consent_waivers.id IS NOT NULL AND
            (accounts.country != 'US' OR
              (background_checks.id IS NOT NULL AND
                background_checks.status = ?))",
          BackgroundCheck.statuses[:clear]
        )

      @permitted_students = @students.joins(:parental_consent)

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
    end
  end
end
