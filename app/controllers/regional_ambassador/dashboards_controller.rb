module RegionalAmbassador
  class DashboardsController < RegionalAmbassadorController
    def show
      if current_ambassador.needs_intro_prompt?
        current_ambassador.regional_links.build
      else
        @students = StudentProfile.current.in_region(current_ambassador)

        @mentors = MentorProfile.current.in_region(current_ambassador)

        if current_ambassador.country == "US"
          init_us_mentor_data
        else
          init_intl_mentor_data
        end

        @permitted_students = @students.joins(:parental_consent)
        @unpermitted_students = @students.left_outer_joins(:parental_consent)
          .where("parental_consents.id IS NULL")

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

    private
    def init_intl_mentor_data
      @consenting_mentors = @mentors.eager_load(account: :consent_waiver)
        .where("consent_waivers.id IS NOT NULL")

      @unconsenting_mentors = @mentors.eager_load(account: :consent_waiver)
        .where("consent_waivers.id IS NULL")
    end

    def init_us_mentor_data
      @cleared_mentors = MentorProfile
        .current
        .in_region(current_ambassador)
        .eager_load(account: [:consent_waiver, :background_check])
        .where(
          "consent_waivers.id IS NOT NULL AND
            background_checks.id IS NOT NULL AND
              background_checks.status = ?",
          BackgroundCheck.statuses[:clear]
        )

      @signed_consent_mentors = MentorProfile
        .current
        .in_region(current_ambassador)
        .eager_load(account: [:consent_waiver, :background_check])
        .where(
          "consent_waivers.id IS NOT NULL AND
            (background_checks.id IS NULL OR
              background_checks.status != ?)",
          BackgroundCheck.statuses[:clear]
        )

      @cleared_bg_check_mentors = MentorProfile
        .current
        .in_region(current_ambassador)
        .eager_load(account: [:consent_waiver, :background_check])
        .where(
          "consent_waivers.id IS NULL AND
            background_checks.id IS NOT NULL AND
              background_checks.status = ?",
          BackgroundCheck.statuses[:clear]
        )

      @niether_mentors = MentorProfile
        .current
        .in_region(current_ambassador)
        .eager_load(account: [:consent_waiver, :background_check])
        .where(
          "consent_waivers.id IS NULL AND
            background_checks.id IS NULL OR
              background_checks.status != ?",
          BackgroundCheck.statuses[:clear]
        )
    end
  end
end
