module RegionalAmbassador
  class DashboardsController < RegionalAmbassadorController
    def show
      if current_ambassador.intro_summary.blank?
        current_ambassador.regional_links.build
      else
        @students = StudentProfile.current.in_region(current_ambassador)

        @mentors = MentorProfile.current.in_region(current_ambassador)

        @cleared_mentors = MentorProfile
          .current
          .in_region(current_ambassador)
          .eager_load(account: [:consent_waiver, :background_check])
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

      @uploader = ImageUploader.new
      @uploader.success_action_redirect =
        regional_ambassador_profile_image_upload_confirmation_url(
          back: regional_ambassador_dashboard_path
        )
      render "regional_ambassador/dashboards/show_#{current_ambassador.status}"
    end
  end
end
