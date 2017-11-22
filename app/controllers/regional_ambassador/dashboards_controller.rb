module RegionalAmbassador
  class DashboardsController < RegionalAmbassadorController
    def show
      if current_ambassador.needs_intro_prompt?
        current_ambassador.regional_links.build
      else
        @top_inactive_mentors = Account.in_region(current_ambassador)
          .not_staff
          .inactive_mentors
          .limit(3)

        @top_inactive_students = Account.in_region(current_ambassador)
          .not_staff
          .inactive_students
          .limit(3)

        @top_inactive_teams = Team.in_region(current_ambassador)
          .not_staff
          .inactive
          .limit(3)

        @students = StudentProfile.current.in_region(current_ambassador)

        @mentors = Account.current.in_region(current_ambassador)
          .left_outer_joins(:mentor_profile)
          .where("mentor_profiles.id IS NOT NULL")

        if current_ambassador.country == "US"
          init_us_mentor_data
        else
          init_intl_mentor_data
        end

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
      end

      render "regional_ambassador/dashboards/show_#{current_ambassador.status}"
    end

    private
    def init_intl_mentor_data
      @consenting_mentors = @mentors.eager_load(:consent_waiver)
        .where("consent_waivers.id IS NOT NULL")

      @unconsenting_mentors = @mentors.eager_load(:consent_waiver)
        .where("consent_waivers.id IS NULL")
    end

    def init_us_mentor_data
      @cleared_mentors = @mentors.bg_check_clear.consent_signed

      @signed_consent_mentors = @mentors.bg_check_submitted.consent_signed

      @cleared_bg_check_mentors = @mentors.bg_check_clear.consent_not_signed

      @neither_mentors = @mentors.bg_check_unsubmitted.consent_not_signed
    end
  end
end
